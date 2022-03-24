# jamf-scripts
This is a collection of scripts used in a Jamf Pro environment. Scripts are written in Bash or Python.

| Filename | Description |
| ----------- | ----------- |
| **dep_notify.sh** | A Bash script that uses [DEPNotify](https://gitlab.com/Mactroll/DEPNotify) to install apps during Mac enrollment. The base script can be found here: https://github.com/jamf/DEPNotify-Starter |
| **set_computer_name_from_filemaker_server.py** | A Python script to name a Mac during enrollment. Queries a FileMaker Server using FileMaker's [Data API](https://help.claris.com/en/data-api-guide/content/index.html) |
| **install_latest_google_chrome_for_enterprise.sh** | A Bash script that downloads and installs the latest version of Google Chrome for Enterprise |
| **install_latest_google_drive_for_desktop.sh** | A Bash script that downloads and installs the latest version of Google Drive for Desktop |
| **install_rosetta_2.sh** | A Bash script that uses the [softwareupdate](https://ss64.com/osx/softwareupdate.html) command to install Rosetta 2 on Apple Silicon Macs |