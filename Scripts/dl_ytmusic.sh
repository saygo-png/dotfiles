#!/bin/sh
output_file=~/Scripts/output.txt
oldoutput_file=~/Scripts/oldoutput.txt
browser_db=~/.librewolf/*.default/sessionstore-backups/recovery.jsonlz4
download_dir=~/Downloads/music/yt_music_rips/

# get urls in history and output and overwrite them to file
lz4jsoncat $browser_db | jq -r .| grep 'https://music.youtube.com/watch?v'| awk '{ print $2 }'| tr -d '",'| awk -F '&' '{print $1}'| sort -u -o$output_file
#compare the curent outputfile to all past entries
grep -F -x -v -f $oldoutput_file $output_file | yt-dlp -x -a - --audio-format opus --audio-quality 0 --no-part -P $download_dir && notify-send "downloaded music"

#add downloaded entries to past entries
cat $output_file >> $oldoutput_file && sort -u $oldoutput_file -o$oldoutput_file
