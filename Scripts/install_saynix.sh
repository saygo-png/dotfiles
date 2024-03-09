#!/bin/bash
set -o pipefail
set -u
shopt -s failglob

# Continue if the script is ran only by non-root.
if (( "$EUID" != 0 )); then
 :
 else
  echo 'Please run without root "./install_saynix.sh"'
  exit
fi

# Ask if stuff is setup properly.
cat << EOF
Have you done the following before running this script?
-Deleted everything in your home directory
-Ran "git clone https://github.com/saygo-png/dotfiles.git ."
EOF
read -rp "(y/N) " create_entry
if [[ $create_entry == "y" || $create_entry == "Y" ]]; then
 :
 else
  echo "Do the steps before running"
  exit
fi


# temporary so i dont fuck up my system when testing script
exit


cd ~/.config/ || exit 1
#update base config
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

# Add repos.
sudo cp -r ~/.config/keyrings/* /etc/apt/keyrings/.
sudo cp -r ~/.config/sources.list.d/* /etc/apt/sources.list.d/.
sudo mkdir -p /etc/apt/keyrings
sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo dpkg --add-architecture i386
sudo apt-get -y update

# Filter packages that can be installed on the system, avoiding "unable to locate package" errors.
# clear old packages-valid
echo -n > packages-valid.txt
while read -r package
do apt show "$package" 2>/dev/null | grep -qvz 'State:.*(virtual)' && echo "$package" >> packages-valid.txt && echo "$package"
done < packagelist.txt

# Install filtered packages.
xargs -a packages-valid.txt sudo apt-get -y install
sudo apt-get -y upgrade

# Install line by line (very slow)
#while read -r line; do sudo apt-get -y install "$line"; done < packagelist.txt

# Change root's shell to zsh
sudo chsh -s "$(which zsh)"

# Install syncthing
sudo apt install syncthing
systemctl --user enable syncthing.service

# Install krita theme.
#mkdir -p ~/.local/share/krita/color-schemes/
#cp ~/.config/KritaWojtrybDarkerRedesignGreenGruvboxed.colors ~/.local/share/krita/color-schemes/


# Install from appman
appman -i krita librewolf blender element schildichat
# Install from pipx
pipx install yt-dlp gallery-dl
# Install from cargo
cargo instal zoxide
# Set ibus delay to 0
gsettings set org.freedesktop.ibus.general switcher-delay-time '0'
# Install polish-finnish keyboard and ms extended
sudo ln -s "$HOME".config/plfi /usr/share/X11/xkb/symbols/plfi
sudo ln -s "$HOME".config/interslavic /usr/share/X11/xkb/symbols/interslavic


# MANUAL INTERVENTION
# Change user's shell to zsh (need manual intervention).
chsh -s "$(which zsh)"

# How to make ibus see the pol-fin keyboard.
#edit the /usr/share/ibus/component/simple.xml file
#pick one of the engines there, and just replace the layout section with "plfi" (name of the xkb file) then turn ibus on and off
#.add the keyboard to input options

# Enable video accel in librewolf.
#(just google it i dont rememember how and it willchange i know its supposed to be an automated script but i dont care)

# Wiktionary finnish search.
#Download the Add custom search engine plugin to Firefox
#Click on it to start adding a new search engine
#Type a name like "FI wiktionary"
#Type the URL with the desired language flag at the end (https://en.wiktionary.org/wiki/%s#Finnish)
#Click save
#Go to Settings -> Search and double-click on the Keyword column
#(right of the search engine names at the bottom table).
#use it by typing the keyword into the search bar
