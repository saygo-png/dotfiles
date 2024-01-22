#!/bin/bash
#fail fast
set -o pipefail -e -u
shopt -s failglob
#safe temp
trap 'rm -r "$tmpfile"' EXIT
tmpfile=$(mktemp -d) || exit 1
echo "temp file is $tmpfile"

OS='linux'
OS_type='amd64'
download_link="https://downloads.rclone.org/rclone-current-linux-amd64.zip"
rclone_zip="rclone-current-linux-amd64.zip"
unzip_dir="tmp_unzip_dir_for_rclone"

version=$(rclone --version 2>>errors | head -n 1)
current_version=$(curl -fsS https://downloads.rclone.org/version.txt)
if [ "$version" = "$current_version" ]; then
 printf "\nThe latest version of rclone is already installed.\n\n"
 exit 3
fi

cd "$tmpfile"
curl -OfsS "$download_link"
7z -y x "$rclone_zip" "-o$unzip_dir"
cd $unzip_dir/*
mv -f rclone ~/.local/bin/rclone
#update version variable post install
version=$(rclone --version 2>>errors | head -n 1)

printf "\n${version} has successfully installed."
exit 0
