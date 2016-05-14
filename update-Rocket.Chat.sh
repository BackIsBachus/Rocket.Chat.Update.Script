#!/bin/bash
ARCHIVE_NAME="rocket.chat.tgz"
TMP_DIR="/tmp/"
INSTALL_DIR="/var/lib/rocket.chat/"
ROCKET_USER="rocketchat"
ROCKET_GROUP="rocketchat"


echo "Fetching latest tarball..."
wget -q https://rocket.chat/releases/latest/download -O $TMP_DIR$ARCHIVE_NAME
NEW_SUM=$(sha256sum -b $TMP_DIR$ARCHIVE_NAME | awk '{print $1}')
OLD_SUM=$(sha256sum -b $INSTALL_DIR$ARCHIVE_NAME | awk '{print $1}')

echo "Checking the tarball hash..."
if [ "$NEW_SUM" != "$OLD_SUM" ]
then
  echo "Newer version available, proceding with update!"
  echo "Stopping Rocket.Chat!"
  systemctl stop rocketchat.service
  mv $TMP_DIR$ARCHIVE_NAME $INSTALL_DIR$ARCHIVE_NAME
  DATE=`date +%Y-%m-%d`
  echo "Creating a backup of the server..."
  tar zcf $INSTALL_DIR"backup_"$DATE".tgz" $INSTALL_DIR"bundle/"
  echo "Unpacking new version..."
  tar zxf $INSTALL_DIR$ARCHIVE_NAME
  OLD_DIR=$(pwd)
  cd $INSTALL_DIR"bundle/programs/server/"
  echo "Installing dependencies with npm..."
  npm install
  cd $OLD_DIR
  echo "Setting the ownership of the files back to the user..."
  chow -R $ROCKET_USER:$ROCKET_GROUP $INSTALL_DIR
  echo "Starting Rocket.Chat!"
  systemctl start rocketchat.service
  echo "Update complete!"
else
  echo "No need to update this already the latest version!"
  rm $TMP_DIR$ARCHIVE_NAME
fi
