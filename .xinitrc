#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#. /etc/X11/Xsession
#above was default config

USRRESOURCES="$HOME"/.config/x11/xresources
ERRFILE="$HOME"/.config/x11/.xsession-errors
# Autostart.
"$HOME"/.config/shell/profile &
xrandr --output HDMI-A-1 --mode 1920x1080 --rate 144 &
autocutsel -s CLIPBOARD &
autocutsel -s PRIMARY &
greenclip daemon &
xrdb "$HOME"/.config/x11/xresources &
picom &
udiskie &
ibus-daemon -x -d -r &
systemctl --user start timers.target &
flameshot &
qbittorrent &
keepassxc &
alacritty &
unclutter-xfixes &
"$HOME"/.local/bin/remaps
exec awesome
