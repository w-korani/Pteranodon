#!/bin/sh

CDIR="$(pwd)"

if test -d /etc/Pteranodon; then rm -rf /etc/Pteranodon; fi

echo "copying over files"
mkdir -p /etc/Pteranodon/
cp -RP $CDIR/*.sh /etc/Pteranodon/

# perms
chmod 555 /etc/Pteranodon/*.sh

echo "Successfully installed"
