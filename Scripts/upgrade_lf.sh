#!/bin/sh
# Safety.
set -u && set -o pipefail && shopt -s failglob

echo "upgrading lf"
cd ~/builds/lf/ || exit
git pull
go build && echo "upgraded lf" || echo "failed lf upgrade"
