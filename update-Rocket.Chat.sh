#!/bin/bash
ARCHIVE_NAME="rocket.chat.tgz"
TMP_DIR="/tmp/"
INSTALL_DIR="/var/lib/rocket.chat/"
ROCKET_USER="rocketchat"
ROCKET_GROUP="rocketchat"
ROCKET_SERVICE="rocketchat"

echo "Fetching latest tarball..."
wget -q https://rocket.chat/releases/latest/download -O $TMP_DIR$ARCHIVE_NAME
NEW_SUM=$(sha256sum -b $TMP_DIR$ARCHIVE_NAME | awk '{print $1}')
OLD_SUM=$(sha256sum -b $INSTALL_DIR$ARCHIVE_NAME | awk '{print $1}')

echo "Checking the tarball hash..."
if [ "$NEW_SUM" != "$OLD_SUM" ]
then
  OLD_DIR=$(pwd)
  DATE=`date +%Y-%m-%d`
  echo "Newer version available, proceding with update!"
  echo "Stopping Rocket.Chat!"
  systemctl stop $ROCKET_SERVICE".service"
  mv $TMP_DIR$ARCHIVE_NAME $INSTALL_DIR$ARCHIVE_NAME
  echo "Creating a backup of the server..."
  cd $INSTALL_DIR
  tar zcf "backup_"$DATE".tgz" "bundle/"
  echo "Unpacking new version..."
  tar zxf $INSTALL_DIR$ARCHIVE_NAME
  OLD_DIR=$(pwd)
  cd $INSTALL_DIR"bundle/programs/server/"
  echo "Installing dependencies with npm..."
  npm install
  cd $OLD_DIR
  echo "Setting the ownership of the files back to the user..."
  chown -R $ROCKET_USER:$ROCKET_GROUP $INSTALL_DIR
  echo "Starting Rocket.Chat!"
  systemctl start $ROCKET_SERVICE".service"
  echo "Update complete!"
else
  echo "No need to update this already the latest version!"
  rm $TMP_DIR$ARCHIVE_NAME
fi
