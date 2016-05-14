# Rocket.Chat.Update.Script
A little bash script to update you Rocket.Chat server if you installed it manually. The script download the latest tarball check if you need to update and does it if necessary while creating a backup of your previous files just in case.

This script suppose you more or less followed the [manual installation tutorial](https://rocket.chat/docs/installation/manual-installation/ubuntu/) (the link is for Ubuntu but it should work the same on other distributions).

This script also supposes that you manage your server with a service, you can find a good template by browsing the [Rocket.Chat Ansible role](https://github.com/RocketChat/Rocket.Chat.Ansible/blob/master/templates/rocketchat.service.j2).

To check if your instalaltion parameters differ from mine you should pay attention to the 5 variable defined at the top of the script:
* `ARCHIVE_NAME` the name of the tarball (that should be located in you install directory)
* `TMP_DIR` the temporary location to download the latest tarball to before checking what to do with it
* `INSTALL_DIR` where your Rocket.Chat server is installed (the folder containing the `bundle/` directory)
* `ROCKET_USER` and `ROCKET_GROUP` the user and group that normally own and run your Rocket.Chat server
