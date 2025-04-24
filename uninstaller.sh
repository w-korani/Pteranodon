#!/bin/sh

CDIR="$(pwd)"

if test -d /etc/Pteranodon; then 
rm -rf /etc/Pteranodon
echo "Successfully uninstalled; please reload ~/.bashrc"
else
echo "KhufuEnv is already uninstalled"
fi
