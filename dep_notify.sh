#!/bin/bash
# Version 2.0.1

#########################################################################################
# License information
#########################################################################################
# Copyright 2018 Jamf Professional Services

# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
# to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or
# substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

#########################################################################################
# General Information
#########################################################################################
# This script is designed to make implementation of DEPNotify very easy with limited
# scripting knowledge. The section below has variables that may be modified to customize
# the end user experience. DO NOT modify things in or below the CORE LOGIC area unless
# major testing and validation is performed.

# More information at: https://github.com/jamfprofessionalservices/DEP-Notify

#########################################################################################
# Testing Mode
#########################################################################################
# Testing flag will enable the following things to change:
# Auto removal of BOM files to reduce errors
# Sleep commands instead of policies or other changes being called
# Quit Key set to command + control + x
  TESTING_MODE=false # Set variable to true or false

###################################################################################################
# Install Python 3 and requests module
###################################################################################################
  /usr/local/bin/jamf policy -event installPython3
  
###################################################################################################
# Logic to name computer
###################################################################################################

# Run the policy to name the computer
  /usr/local/bin/jamf policy -event nameComputer

# Store computer name in a variable
  COMPUTER_NAME=$(scutil --get LocalHostName)

###################################################################################################

#########################################################################################
# General Appearance
#########################################################################################

# Set fullscreen variable
  FULLSCREEN=true

# Download Banner Image
  curl -o /tmp/banner_image.png https://YOUR_URL/banner_image.png

# Banner image can be 600px wide by 100px high. Images will be scaled to fit
# If this variable is left blank, the generic image will appear. If using custom Self
# Service branding, please see the Customized Self Service Branding area below
  BANNER_IMAGE_PATH="/tmp/banner_image.png"

# Main heading that will be displayed under the image
# If this variable is left blank, the generic banner will appear
  BANNER_TITLE="ORGANIZATION_NAME"

# Determine computer model
  COMPUTER_MODEL=$(system_profiler SPHardwareDataType | grep "Model Name" | awk -F": " '{print $2}')

# Paragraph text that will display under the main heading. For a new line, use \n
# If this variable is left blank, the generic message will appear. Leave single
# quotes below as double quotes will break the new lines.
  MAIN_TEXT="Configuring this $COMPUTER_MODEL for: \n $COMPUTER_NAME \n \n This process should take 20 to 30 minutes to complete."

# Initial Start Status text that shows as things are firing up
  INITAL_START_STATUS="Initial Configuration Starting..."

# Complete messaging to the end user can ether be a button at the bottom of the
# app with a modification to the main window text or a dropdown alert box. Default
# value set to false and will use buttons instead of dropdown messages.
  COMPLETE_METHOD_DROPDOWN_ALERT=false # Set variable to true or false

# Text that will display inside the alert once policies have finished

  COMPLETE_MAIN_TEXT='Configuration Complete! Click the button below to quit'

  COMPLETE_BUTTON_TEXT="Quit"

#########################################################################################
# Plist Configuration
#########################################################################################
# The menu.depnotify.plist contains more and more things that configure the DEPNotify app
# You may want to save the file for purposes like verifying EULA acceptance or validating
# other options.

# Plist Save Location
  # This wrapper allows variables that are created later to be used but also allow for
  # configuration of where the plist is stored
    INFO_PLIST_WRAPPER (){
      DEP_NOTIFY_USER_INPUT_PLIST="/Users/$CURRENT_USER/Library/Preferences/menu.nomad.DEPNotifyUserInput.plist"
    }

# Status Text Alignment
  # The status text under the progress bar can be configured to be left, right, or center
    STATUS_TEXT_ALIGN="center"

# Help Button Configuration
  # The help button was changed to a popup. Button will appear if title is populated.
    HELP_BUBBLE_TITLE="Need Help?"
    HELP_BUBBLE_BODY="This tool is used for deploying Macs at ORGANIZATION_NAME"

#########################################################################################
# Error Screen Text
#########################################################################################
# If testing mode is false and configuration files are present, this text will appear to
# the end user and asking them to contact IT. Limited window options here as the
# assumption is that they need to call IT. No continue or exit buttons will show for
# DEP Notify window and it will not show in fullscreen. IT staff will need to use Terminal
# or Activity Monitor to kill DEP Notify.

# Main heading that will be displayed under the image
  ERROR_BANNER_TITLE="Uh oh, Something Needs Fixing!"

# Paragraph text that will display under the main heading. For a new line, use \n
# If this variable is left blank, the generic message will appear. Leave single
# quotes below as double quotes will break the new lines.
  ERROR_MAIN_TEXT='An Error has occurred. \n \n Please contact the IT department.'

# Error status message that is displayed under the progress bar
  ERROR_STATUS="Setup Failed"

#########################################################################################
# Policy Variables
#########################################################################################

# The policy arrays must be formatted "Progress Bar text,customTrigger". These will be
# run in order as they appear below.

  STAFF_POLICY_ARRAY_BIG_SUR=(
      "Installing Rosetta 2,installRosetta2"
      "Installing Google Apps,googleApps"
      "Installing Microsoft Office 2019,microsoftOffice2019"
      "Installing SMART Learning Suite,smartLearningSuite"
      "Installing Canon Copier Drivers,canonDrivers"
      "Installing HP Printer Drivers,hpPrinterDrivers"
      "Setting Login Window Text,setLoginWindowText"
      "Setting Admin Desktop Picture,setAdminDesktopPicture"
      "Kicking off Restart Watchdog to Rebuild Kernel Cache,kickoffRestartWatchdog"
  )

  STUDENT_POLICY_ARRAY_BIG_SUR=(
      "Installing Rosetta 2,installRosetta2"
      "Installing Google Apps,googleApps"
      "Installing Microsoft Office 2019,microsoftOffice2019"
      "Installing Canon Copier Drivers,canonDrivers"
      "Installing HP Printer Drivers,hpPrinterDrivers"
      "Installing Lightspeed Relay Smart Agent,installRelaySmartAgent177"
      "Setting Login Window Text,setLoginWindowText"
      "Setting Admin Desktop Picture,setAdminDesktopPicture"
      "Kicking off Restart Watchdog to Rebuild Kernel Cache,kickoffRestartWatchdog"
  )    

  STAFF_POLICY_ARRAY_MOJAVE=(
      "Setting Admin Desktop Picture,setAdminDesktopPicture"
      "Installing Google Apps,googleApps"
      "Installing Microsoft Office 2019,microsoftOffice2019"
      "Installing SMART Learning Suite,smartLearningSuite"
      "Installing Canon Copier Drivers,canonDrivers"
      "Installing HP Printer Drivers,hpPrinterDrivers"
      "Installing Lightspeed Rocket User Agent,lsrUserAgent"
  )

  STUDENT_POLICY_ARRAY_MOJAVE=(
      "Setting Admin Desktop Picture,setAdminDesktopPicture"
      "Installing Google Apps,googleApps"
      "Installing Microsoft Office 2019,microsoftOffice2019"
      "Installing Canon Copier Drivers,canonDrivers"
      "Installing HP Printer Drivers,hpPrinterDrivers"
      "Installing Lightspeed Relay Smart Agent,installRelaySmartAgent152"
  )

#########################################################################################
# Determine macOS verison and computer type
#########################################################################################

# Determine macOS version
MACOS_VERSION=$(sw_vers -productVersion)

# Declare Computer Type variable
COMPUTER_TYPE="None"

# Set Computer Type variable and write string to ARD Field 1
if [[ $COMPUTER_NAME =~ ^Staff.* ]]; then
  COMPUTER_TYPE="Staff"
  /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 Staff
elif [[ $COMPUTER_NAME =~ ^20.*|Cart|Classroom|Loaner|Student ]]; then
  COMPUTER_TYPE="Student"
  /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 Student
fi

#########################################################################################
# Set policy array and additional variables based on macOS verison and computer type
#########################################################################################

if [[ $MACOS_VERSION =~ ^11 || $MACOS_VERSION =~ ^12 ]]; then
  # Computer is running macOS 11 Big Sur or later
  COMPLETE_MAIN_TEXT='Configuration Complete! Click the button below to restart'
  if [[ $COMPUTER_TYPE == "Staff" ]]; then
    POLICY_ARRAY=("${STAFF_POLICY_ARRAY_BIG_SUR[@]}")
    COMPLETE_BUTTON_TEXT="Restart"
  elif [[ $COMPUTER_TYPE == "Student" ]]; then
    POLICY_ARRAY=("${STUDENT_POLICY_ARRAY_BIG_SUR[@]}")
    COMPLETE_BUTTON_TEXT="Restart"
  fi
elif [[ $MACOS_VERSION =~ ^10.14 ]]; then
  # Computer is running macOS 10.14 Mojave
  if [[ $COMPUTER_TYPE == "Staff" ]]; then
    POLICY_ARRAY=("${STAFF_POLICY_ARRAY_MOJAVE[@]}")
  elif [[ $COMPUTER_TYPE == "Student" ]]; then
    POLICY_ARRAY=("${STUDENT_POLICY_ARRAY_MOJAVE[@]}")
  fi
fi

#########################################################################################
# Caffeinate / No Sleep Configuration
#########################################################################################
# Flag script to keep the computer from sleeping. BE VERY CAREFUL WITH THIS FLAG!
# This flag could expose your data to risk by leaving an unlocked computer wide open.
# Only recommended if you are using fullscreen mode and have a logout taking place at
# the end of configuration (like for FileVault). Some folks may use this in workflows
# where IT staff are the primary people setting up the device. The device will be
# allowed to sleep again once the DEPNotify app is quit as caffeinate is looking
# at DEPNotify's process ID.
  NO_SLEEP=true

#########################################################################################
# Customized Self Service Branding
#########################################################################################
# Flag for using the custom branding icon from Self Service and Jamf Pro
# This will override the banner image specified above. If you have changed the
# name of Self Service, make sure to modify the Self Service name below.
# Please note, custom branding is downloaded from Jamf Pro after Self Service has opened
# at least one time. The script is designed to wait until the files have been downloaded.
# This could take a few minutes depending on server and network resources.
  SELF_SERVICE_CUSTOM_BRANDING=false # Set variable to true or false

# If using a name other than Self Service with Custom branding. Change the
# name with the SELF_SERVICE_APP_NAME variable below. Keep .app on the end
  SELF_SERVICE_APP_NAME="Self Service.app"

#########################################################################################
# EULA Variables to Modify
#########################################################################################
# EULA configuration
  EULA_ENABLED=false # Set variable to true or false

#########################################################################################
# Registration Variables to Modify
#########################################################################################
# Registration window configuration
  REGISTRATION_ENABLED=false # Set variable to true or false

#########################################################################################
#########################################################################################
# Core Script Logic - Don't Change Without Major Testing
#########################################################################################
#########################################################################################

# Variables for File Paths
  JAMF_BINARY="/usr/local/bin/jamf"
  FDE_SETUP_BINARY="/usr/bin/fdesetup"
  DEP_NOTIFY_APP="/Applications/Utilities/DEPNotify.app"
  DEP_NOTIFY_LOG="/var/tmp/depnotify.log"
  DEP_NOTIFY_DEBUG="/var/tmp/depnotifyDebug.log"
  DEP_NOTIFY_DONE="/var/tmp/com.depnotify.provisioning.done"

# Pulling from Policy parameters to allow true/false flags to be set. More info
# can be found on https://www.jamf.com/jamf-nation/articles/146/script-parameters
# These will override what is specified in the script above.
  # Testing Mode
    if [ "$4" != "" ]; then TESTING_MODE="$4"; fi
  # Fullscreen Mode
    if [ "$5" != "" ]; then FULLSCREEN="$5"; fi
  # No Sleep / Caffeinate Mode
    if [ "$6" != "" ]; then NO_SLEEP="$6"; fi
  # Self Service Custom Branding
    if [ "$7" != "" ]; then SELF_SERVICE_CUSTOM_BRANDING="$7"; fi
  # Complete method dropdown or main screen
    if [ "$8" != "" ]; then COMPLETE_METHOD_DROPDOWN_ALERT="$8"; fi
  # EULA Mode
    # if [ "$9" != "" ]; then EULA_ENABLED="$9"; fi
  # Registration Mode
    # if [ "${10}" != "" ]; then REGISTRATION_ENABLED="${10}"; fi

# Standard Testing Mode Enhancements
  if [ "$TESTING_MODE" = true ]; then
    # Removing old config file if present (Testing Mode Only)
      if [ -f "$DEP_NOTIFY_LOG" ]; then rm "$DEP_NOTIFY_LOG"; fi
      if [ -f "$DEP_NOTIFY_DONE" ]; then rm "$DEP_NOTIFY_DONE"; fi
      if [ -f "$DEP_NOTIFY_DEBUG" ]; then rm "$DEP_NOTIFY_DEBUG"; fi
    # Setting Quit Key set to command + control + x (Testing Mode Only)
      echo "Command: QuitKey: x" >> "$DEP_NOTIFY_LOG"
  fi

# Validating true/false flags
  if [ "$TESTING_MODE" != true ] && [ "$TESTING_MODE" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Testing configuration not set properly. Currently set to $TESTING_MODE. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$FULLSCREEN" != true ] && [ "$FULLSCREEN" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Fullscreen configuration not set properly. Currently set to $FULLSCREEN. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$NO_SLEEP" != true ] && [ "$NO_SLEEP" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Sleep configuration not set properly. Currently set to $NO_SLEEP. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$SELF_SERVICE_CUSTOM_BRANDING" != true ] && [ "$SELF_SERVICE_CUSTOM_BRANDING" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Self Service Custom Branding configuration not set properly. Currently set to $SELF_SERVICE_CUSTOM_BRANDING. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$COMPLETE_METHOD_DROPDOWN_ALERT" != true ] && [ "$COMPLETE_METHOD_DROPDOWN_ALERT" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Completion alert method not set properly. Currently set to $COMPLETE_METHOD_DROPDOWN_ALERT. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$EULA_ENABLED" != true ] && [ "$EULA_ENABLED" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): EULA configuration not set properly. Currently set to $EULA_ENABLED. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi
  if [ "$REGISTRATION_ENABLED" != true ] && [ "$REGISTRATION_ENABLED" != false ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Registration configuration not set properly. Currently set to $REGISTRATION_ENABLED. Please update to true or false." >> "$DEP_NOTIFY_DEBUG"
    exit 1
  fi

# Run DEP Notify will run after Apple Setup Assistant
  SETUP_ASSISTANT_PROCESS=$(pgrep -l "Setup Assistant")
  until [ "$SETUP_ASSISTANT_PROCESS" = "" ]; do
    echo "$(date "+%a %h %d %H:%M:%S"): Setup Assistant Still Running. PID $SETUP_ASSISTANT_PROCESS." >> "$DEP_NOTIFY_DEBUG"
    sleep 1
    SETUP_ASSISTANT_PROCESS=$(pgrep -l "Setup Assistant")
  done

# Checking to see if the Finder is running now before continuing. This can help
# in scenarios where an end user is not configuring the device.
  FINDER_PROCESS=$(pgrep -l "Finder")
  until [ "$FINDER_PROCESS" != "" ]; do
    echo "$(date "+%a %h %d %H:%M:%S"): Finder process not found. Assuming device is at login screen." >> "$DEP_NOTIFY_DEBUG"
    sleep 1
    FINDER_PROCESS=$(pgrep -l "Finder")
  done

# After the Apple Setup completed. Now safe to grab the current user.
  CURRENT_USER=$(/usr/bin/stat -f "%Su" /dev/console)
  echo "$(date "+%a %h %d %H:%M:%S"): Current user set to $CURRENT_USER." >> "$DEP_NOTIFY_DEBUG"

# Adding Check and Warning if Testing Mode is off and BOM files exist
  if [[ ( -f "$DEP_NOTIFY_LOG" || -f "$DEP_NOTIFY_DONE" ) && "$TESTING_MODE" = false ]]; then
    echo "$(date "+%a %h %d %H:%M:%S"): TESTING_MODE set to false but config files were found in /var/tmp. Letting user know and exiting." >> "$DEP_NOTIFY_DEBUG"
    mv "$DEP_NOTIFY_LOG" "/var/tmp/depnotify_old.log"
    echo "Command: MainTitle: $ERROR_BANNER_TITLE" >> "$DEP_NOTIFY_LOG"
    echo "Command: MainText: $ERROR_MAIN_TEXT" >> "$DEP_NOTIFY_LOG"
    echo "Status: $ERROR_STATUS" >> "$DEP_NOTIFY_LOG"
    sudo -u "$CURRENT_USER" open -a "$DEP_NOTIFY_APP" --args -path "$DEP_NOTIFY_LOG"
    sleep 5
    exit 1
  fi

# If SELF_SERVICE_CUSTOM_BRANDING is set to true. Loading the updated icon
  if [ "$SELF_SERVICE_CUSTOM_BRANDING" = true ]; then
    open -a "/Applications/$SELF_SERVICE_APP_NAME" --hide

  # Loop waiting on the branding image to properly show in the users library
  CUSTOM_BRANDING_PNG="/Users/$CURRENT_USER/Library/Application Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
    until [ -f "$CUSTOM_BRANDING_PNG" ]; do
      echo "$(date "+%a %h %d %H:%M:%S"): Waiting for branding image from Jamf Pro." >> "$DEP_NOTIFY_DEBUG"
       sleep 1
    done

  # Setting Banner Image for DEP Notify to Self Service Custom Branding
    BANNER_IMAGE_PATH="$CUSTOM_BRANDING_PNG"

  # Closing Self Service
    SELF_SERVICE_PID=$(pgrep -l "$(echo "$SELF_SERVICE_APP_NAME" | cut -d "." -f1)" | cut -d " " -f1)
    echo "$(date "+%a %h %d %H:%M:%S"): Self Service custom branding icon has been loaded. Killing Self Service PID $SELF_SERVICE_PID." >> "$DEP_NOTIFY_DEBUG"
    kill "$SELF_SERVICE_PID"
  fi

# Setting custom image if specified
  if [ "$BANNER_IMAGE_PATH" != "" ]; then  echo "Command: Image: $BANNER_IMAGE_PATH" >> "$DEP_NOTIFY_LOG"; fi

# Setting custom title if specified
  if [ "$BANNER_TITLE" != "" ]; then echo "Command: MainTitle: $BANNER_TITLE" >> "$DEP_NOTIFY_LOG"; fi

# Setting custom main text if specified
  if [ "$MAIN_TEXT" != "" ]; then echo "Command: MainText: $MAIN_TEXT" >> "$DEP_NOTIFY_LOG"; fi

# General Plist Configuration
  # Calling function to set the INFO_PLIST_PATH
    INFO_PLIST_WRAPPER

  # The plist information below
    DEP_NOTIFY_CONFIG_PLIST="/Users/$CURRENT_USER/Library/Preferences/menu.nomad.DEPNotify.plist"

  # If testing mode is on, this will remove some old configuration files
    if [ "$TESTING_MODE" = true ] && [ -f "$DEP_NOTIFY_CONFIG_PLIST" ]; then rm "$DEP_NOTIFY_CONFIG_PLIST"; fi
    if [ "$TESTING_MODE" = true ] && [ -f "$DEP_NOTIFY_USER_INPUT_PLIST" ]; then rm "$DEP_NOTIFY_USER_INPUT_PLIST"; fi

  # Setting default path to the plist which stores all the user completed info
    defaults write "$DEP_NOTIFY_CONFIG_PLIST" pathToPlistFile "$DEP_NOTIFY_USER_INPUT_PLIST"

  # Setting status text alignment
    defaults write "$DEP_NOTIFY_CONFIG_PLIST" statusTextAlignment "$STATUS_TEXT_ALIGN"

  # Setting help button
    if [ "$HELP_BUBBLE_TITLE" != "" ]; then
      defaults write "$DEP_NOTIFY_CONFIG_PLIST" helpBubble -array-add "$HELP_BUBBLE_TITLE"
      defaults write "$DEP_NOTIFY_CONFIG_PLIST" helpBubble -array-add "$HELP_BUBBLE_BODY"
    fi

# Changing Ownership of the plist file
  chown "$CURRENT_USER":staff "$DEP_NOTIFY_CONFIG_PLIST"
  chmod 600 "$DEP_NOTIFY_CONFIG_PLIST"

################################################################
# Launch DEPNotify.app
# Opening the app after initial configuration
################################################################
  if [ "$FULLSCREEN" = true ]; then
    sudo -u "$CURRENT_USER" open -a "$DEP_NOTIFY_APP" --args -path "$DEP_NOTIFY_LOG" -fullScreen
  elif [ "$FULLSCREEN" = false ]; then
    sudo -u "$CURRENT_USER" open -a "$DEP_NOTIFY_APP" --args -path "$DEP_NOTIFY_LOG"
  fi

# Grabbing the DEP Notify Process ID for use later
  DEP_NOTIFY_PROCESS=$(pgrep -l "DEPNotify" | cut -d " " -f1)
  until [ "$DEP_NOTIFY_PROCESS" != "" ]; do
    echo "$(date "+%a %h %d %H:%M:%S"): Waiting for DEPNotify to start to gather the process ID." >> "$DEP_NOTIFY_DEBUG"
    sleep 1
    DEP_NOTIFY_PROCESS=$(pgrep -l "DEPNotify" | cut -d " " -f1)
  done

# Using Caffeinate binary to keep the computer awake if enabled
  if [ "$NO_SLEEP" = true ]; then
    echo "$(date "+%a %h %d %H:%M:%S"): Caffeinating DEP Notify process. Process ID: $DEP_NOTIFY_PROCESS" >> "$DEP_NOTIFY_DEBUG"
    caffeinate -disu -w "$DEP_NOTIFY_PROCESS"&
  fi

# Adding an alert prompt to let admins know that the script is in testing mode
  if [ "$TESTING_MODE" = true ]; then
    echo "Command: Alert: DEP Notify is in TESTING_MODE. Script will not run Policies or other commands that make change to this computer."  >> "$DEP_NOTIFY_LOG"
  fi

# Adding nice text and a brief pause for prettiness
  echo "Status: $INITAL_START_STATUS" >> "$DEP_NOTIFY_LOG"
  sleep 5

# Setting the status bar
  # Counter is for making the determinate look nice. Starts at one and adds
  # more based on EULA, register, or other options.
    ADDITIONAL_OPTIONS_COUNTER=0
    if [ "$EULA_ENABLED" = true ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
    if [ "$REGISTRATION_ENABLED" = true ]; then ((ADDITIONAL_OPTIONS_COUNTER++))
      if [ "$REG_TEXT_LABEL_1" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
      if [ "$REG_TEXT_LABEL_2" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
      if [ "$REG_POPUP_LABEL_1" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
      if [ "$REG_POPUP_LABEL_2" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
      if [ "$REG_POPUP_LABEL_3" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
      if [ "$REG_POPUP_LABEL_4" != "" ]; then ((ADDITIONAL_OPTIONS_COUNTER++)); fi
    fi

  # Checking policy array and adding the count from the additional options above.
    # ARRAY_LENGTH="$((${#POLICY_ARRAY[@]}+ADDITIONAL_OPTIONS_COUNTER))"
    # echo "Command: Determinate: $ARRAY_LENGTH" >> "$DEP_NOTIFY_LOG"

# Record the start time
  START_TIME=$(date +%s);

################################################################
# Loop through policy array
################################################################

# Loop to run policies
  ARRAY_LENGTH="$((${#POLICY_ARRAY[@]}+ADDITIONAL_OPTIONS_COUNTER))"

  echo "Command: Determinate: $ARRAY_LENGTH" >> "$DEP_NOTIFY_LOG"
  for POLICY in "${POLICY_ARRAY[@]}"; do
    echo "Status: $(echo "$POLICY" | cut -d ',' -f1)" >> "$DEP_NOTIFY_LOG"
    if [ "$TESTING_MODE" = true ]; then
      sleep 5
    elif [ "$TESTING_MODE" = false ]; then
      "$JAMF_BINARY" policy -event "$(echo "$POLICY" | cut -d ',' -f2)"
    fi
  done

################################################################
# The Microsoft AutoUpdate Required Data Notice dialog window will appear by default
# This can be suppressed via a configuration profile
# See: https://www.kevinmcox.com/2024/04/changes-to-microsoft-autoupdates-required-data-notice/
################################################################

# Record the end time
  END_TIME=$(date +%s);
  
# Calculate time taken and format string for display 
  TIME_TAKEN=$(echo $((END_TIME-START_TIME)) | awk '{printf " %d minutes and %d seconds", ($1/60)%60, $1%60}')

# Change status text to display time taken
  echo "Status: $TIME_TAKEN" >> "$DEP_NOTIFY_LOG"

# Run the Jamf Manage command to force profiles 
  /usr/local/bin/jamf manage

# Hide DEPNotify app in Finder
  /usr/bin/chflags hidden /Applications/Utilities/DEPNotify.app

################################################################
# Display completion text & button
################################################################

echo "Command: MainText: $COMPLETE_MAIN_TEXT" >> "$DEP_NOTIFY_LOG"
echo "Command: ContinueButton: $COMPLETE_BUTTON_TEXT" >> "$DEP_NOTIFY_LOG"

################################################################
# Play a sound to indicate that the process is complete
################################################################
osascript -e "set Volume 7"
afplay /System/Library/Sounds/Basso.aiff
osascript -e "set Volume 3.5"

exit 0