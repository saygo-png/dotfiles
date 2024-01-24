#!/bin/bash
# Safety.
set -u && set -o pipefail && shopt -s failglob

# Make temp diretory and delete on exit signal.
trap 'rm -r "$tmpfile"' EXIT
tmpfile=$(mktemp -d) || exit 1
echo "temp file is $tmpfile"

# Set variables.
download_link="https://downloads.rclone.org/rclone-current-linux-amd64.zip"
rclone_zip="rclone-current-linux-amd64.zip"
unzip_dir="tmp_unzip_dir_for_rclone"
version=$(rclone --version 2>>errors | head -n 1)
current_version=$(curl -fsS https://downloads.rclone.org/version.txt)

# Check if versions differ.
if [ "$version" = "$current_version" ]; then
 printf "\nThe latest version of rclone is already installed.\n\n"
 exit 3
fi

# Install.
cd "$tmpfile"
curl -OfsS "$download_link"
7z -y x "$rclone_zip" "-o$unzip_dir"
cd $unzip_dir/*
mv -f rclone ~/.local/bin/rclone

# Update version variable post install.
version=$(rclone --version 2>>errors | head -n 1)

printf "\n${version} has successfully installed."
exit
