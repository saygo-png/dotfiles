#!/bin/sh
# Autostart.
"$HOME"/.config/shell/profile &
#. /etc/X11/Xsession &
xrandr --output HDMI-A-1 --mode 1920x1080 --rate 144 &
autocutsel -s CLIPBOARD &
autocutsel -s PRIMARY &
greenclip daemon &
xrdb "$HOME"/.config/x11/xresources &
picom &
udiskie &
#ibus-daemon -x -d -r &
systemctl --user start timers.target &
flameshot &
alacritty &
librewolf &
#unclutter-xfixes &
"$HOME"/.local/bin/remaps
#exec dbus-launch --exit-with-session awesome
awesome
