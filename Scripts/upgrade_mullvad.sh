#!/bin/bash
set -o pipefail
set -u
shopt -s failglob

#make temp working directory
trap 'rm -r "$tmpfile"' EXIT
tmpfile=$(mktemp -d) || exit 1
echo "temp file is $tmpfile"

cd "$tmpfile" || exit
#get .deb, check if the file downloaded file is the same, if it is then don't update, if its not, update
wget -N https://mullvad.net/en/download/app/deb/latest 2>&1 | grep 'File ‘latest’ not modified on server. Omitting download.'
if [ $? -eq 0 ]; then
  echo "Mullvad already up-to-date."
  exit
 else
  echo "Attempting install"
  for f in "$tmpfile"/mullvad/*; do
   sudo gdebi "$f" && echo "Mullvad done" || echo "Error while updating Mullvad"
  done
 exit
fi
