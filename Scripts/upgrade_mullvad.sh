#!/bin/zsh
#make temp working directory
mkdir /tmp/mullvad
cd /tmp/mullvad
trash /tmp/mullvad/*
#get .deb
wget -N https://mullvad.net/en/download/app/deb/latest
sudo gdebi /tmp/mullvad/*
echo "Mullvad done"
