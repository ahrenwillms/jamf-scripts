#!/bin/bash

# Installs Rosetta 2 on Apple Silicon machines

ARCH=$(/usr/bin/arch)

if [ "$ARCH" == "arm64" ]; then
    echo "Architecture is Apple Silicon - Installing Rosetta 2"
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
elif [ "$ARCH" == "i386" ]; then
    echo "Architecture is Intel - No Need to Install Rosetta 2"
else
    echo "Unknown Architecture"
fi

exit 0