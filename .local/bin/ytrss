#!/bin/bash
echo "https://www.youtube.com/feeds/videos.xml?channel_id=$(curl -s "$1" | grep -i "channelid" | sed 's/^.*:{"channelId"//; s/",".*$//; s/:"//' | head -n1)"
