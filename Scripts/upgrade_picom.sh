#!/bin/sh
# Safety.
set -u && set -o pipefail && shopt -s failglob

echo "upgrading picom"
cd ~/builds/picom/ || exit
git pull || exit
meson setup --buildtype=release build && sudo ninja -C build install || echo "failed picom" && echo "upgraded picom" || echo "failed picom"
