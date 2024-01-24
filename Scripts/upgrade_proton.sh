#!/bin/bash
# Safety.
set -u && set -o pipefail && shopt -s failglob

# Make temp working directory.
trap 'rm -r "$tmpfile"' EXIT
tmpfile=$(mktemp -d) || exit 1
echo "temp file is $tmpfile"
cd "$tmpfile"

# Get tarball.
wget -N "$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E .tar.gz)"

# Make steam directory if it does not exist.
mkdir -p ~/.steam/root/compatibilitytools.d

# Unpack.
aunpack -e GE-Proton*.tar.gz -X ~/.steam/root/compatibilitytools.d/
echo "Steam Proton done"

# Make wine directory if it does not exist.
mkdir -p ~/.local/share/lutris/runners/wine/

# Get tarballs.
wget -N "$(curl -s https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases | grep browser_download_url | cut -d\" -f4 | grep -E LoL | grep -E .tar.xz)"
wget -N "$(curl -s https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | grep browser_download_url | cut -d\" -f4 | grep -E -v LoL | grep -E .tar.xz)"

# Unpack.
aunpack -e wine-lutris-*.tar.xz -X ~/.local/share/lutris/runners/wine/

echo "Proton done"
exit
