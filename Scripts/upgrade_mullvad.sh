#!/bin/sh
#make temp working directory
mkdir /tmp/mullvad
cd /tmp/mullvad
trash /tmp/mullvad/*
#get .deb, check if the file downloaded file is the same, if it is then don't update, if its not, update
wget -N https://mullvad.net/en/download/app/deb/latest 2>&1 | grep 'File ‘latest’ not modified on server. Omitting download.'
if [ $? -eq 0 ]; then
 echo "Mullvad already up-to-date."
 exit
else
 echo "Attempting install"
 sudo gdebi /tmp/mullvad/* && echo "Mullvad done" || echo "Error while updating Mullvad"
 exit
fi
