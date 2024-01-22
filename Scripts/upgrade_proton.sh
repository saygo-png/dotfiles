#!/bin/bash
#make temp working directory
set -o pipefail -e -u
shopt -s failglob

trap 'rm -r "$tmpfile"' EXIT
tmpfile=$(mktemp -d) || exit 1
echo "temp file is $tmpfile"
cd "$tmpfile"

#tarball
wget -N $(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep .tar.gz)

#make steam directory if it does not exist
mkdir -p ~/.steam/root/compatibilitytools.d

#unpack
aunpack -e GE-Proton*.tar.gz -X ~/.steam/root/compatibilitytools.d/
echo "Steam Proton done"

#make wine directory if it does not exist
mkdir -p ~/.local/share/lutris/runners/wine/

#tarballs
wget -N $(curl -s https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases | grep browser_download_url | cut -d\" -f4 | egrep LoL | egrep .tar.xz)

wget -N $(curl -s https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | egrep -v LoL | egrep .tar.xz)

#unpack
aunpack -e wine-lutris-*.tar.xz -X ~/.local/share/lutris/runners/wine/

echo "Proton done"
