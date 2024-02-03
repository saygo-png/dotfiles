#!/bin/sh
xdotool type "$(grep -v '^#' "${HOME}"/Sync/bookmarks/urls.txt | rofi -dmenu -i | cut -d' ' -f1)"
