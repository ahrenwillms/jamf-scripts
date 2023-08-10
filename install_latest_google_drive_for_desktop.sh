#!/bin/bash

# Download DMG file from Google
curl -o /tmp/GoogleDrive.dmg https://dl.google.com/drive-file-stream/GoogleDrive.dmg

# Mount the disk image
hdiutil mount /tmp/GoogleDrive.dmg

# Install the package
installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target /

# Unmount the disk image
hdiutil unmount /Volumes/Install\ Google\ Drive/

# Remove the DMG file
rm /tmp/GoogleDrive.dmg

exit 0