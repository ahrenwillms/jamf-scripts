#!/bin/bash

curl -o /tmp/GoogleDrive.dmg https://dl.google.com/drive-file-stream/GoogleDrive.dmg

hdiutil mount /tmp/GoogleDrive.dmg

installer -pkg /Volumes/Install\ Google\ Drive/GoogleDrive.pkg -target /

hdiutil unmount /Volumes/Install\ Google\ Drive/

rm /tmp/GoogleDrive.dmg

exit 0