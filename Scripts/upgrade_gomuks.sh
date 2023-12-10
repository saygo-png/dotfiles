#!/bin/sh
echo "upgrading gomuks"
cd ~/builds/gomuks/
git pull
~/builds/gomuks/build.sh && echo "upgraded gomuks" || echo "failed upgrade"
