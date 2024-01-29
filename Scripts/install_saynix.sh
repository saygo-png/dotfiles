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


#temporary so i dont fuck up my system when testing script
exit


cd ~/.config/ || exit 1
#update base config
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

#add repos
sudo cp -r ~/.config/keyrings/* /etc/apt/keyrings/.
sudo cp -r ~/.config/sources.list.d/* /etc/apt/sources.list.d/.
sudo apt-get -y update

# Filter packages that can be installed on the system, avoiding "unable to locate package" errors.
 #clear old packages-valid
echo -n > packages-valid.txt
while read package
do apt show "$package" 2>/dev/null | grep -qvz 'State:.*(virtual)' && echo "$package" >> packages-valid.txt && echo "$package"
done < packagelist.txt

# Install filtered packages.
xargs -a packages-valid.txt sudo apt-get -y install
sudo apt-get -y upgrade

# #replace rm with rmw (trash)
# sudo ln -s /bin/rmw /usr/local/bin/rm

# Install krita theme.
mkdir -p ~/.local/share/krita/color-schemes/
cp ~/.config/KritaWojtrybDarkerRedesignGreenGruvboxed.colors ~/.local/share/krita/color-schemes/

# Enable video accel in librewolf. (just google it i dont rememember how and it willc hange i know its supposed to be an automated script but i dont care)
