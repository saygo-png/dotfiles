#!/bin/sh
echo "upgrading picom"
cd ~/builds/picom/
git pull
meson setup --buildtype=release build && sudo ninja -C build install || echo "failed picom" && echo "upgraded picom" || echo "failed picom"
