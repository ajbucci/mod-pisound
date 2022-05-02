#!/bin/sh

#remove all created services and folders created by install.sh, service files are in /usr/lib/systemd/system/browsepy.servic
echo "Removing Services"
sudo rm /usr/lib/systemd/system/browsepy.service
sudo rm /usr/lib/systemd/system/mod-host.service
sudo rm /usr/lib/systemd/system/mod-ui.service
sudo rm /usr/lib/systemd/system/amidiauto.service

echo "Removing Folders"
sudo rm /home/raspberryUsername/.lv2 -rf
sudo rm /home/raspberryUsername/data -rf
sudo rm /home/raspberryUsername/mod -rf