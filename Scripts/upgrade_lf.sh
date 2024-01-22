#!/bin/sh
echo "upgrading lf"
cd ~/builds/lf/ || exit
git pull
go build && echo "upgraded lf" || echo "failed lf upgrade"
