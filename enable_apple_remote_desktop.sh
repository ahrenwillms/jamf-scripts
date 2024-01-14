#!/bin/bash

#########################################################################################
# Enable Apple Remote Desktop via Jamf API
#########################################################################################

#########################################################################################
# Credit to Matthew Warren and Richard Purves for the methods used for Jamf API calls and JSON parsing
# https://richard-purves.com/2021/12/09/jamf-pro-api-for-fun-and-profit/
#########################################################################################

# Generate API base64 credentials by using:
# printf "username:password" | iconv -t ISO-8859-1 | base64 -i -
BASE64_API_CREDENTIALS="YOUR_API_CREDENTIALS"

# Grab the JSS URL from the Jamf plist
JSS_URL=$( /usr/bin/defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url )

# Grab the Hardware UDID of the Mac
HARDWARE_UDID=$( /usr/sbin/ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformUUID/ { split($0, line, "\""); printf("%s\n", line[4]); }' )

# Use our base64 creds to generate a temporary API access token in JSON form
# Use tr to strip out line feeds or the JXA will not like the input
# Retrieve the read token from the JSON response
JSON_RESPONSE=$( /usr/bin/curl -s "${JSS_URL}api/v1/auth/token" -H "authorization: Basic ${BASE64_API_CREDENTIALS}" -X POST | tr -d "\n" )
TOKEN=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$JSON_RESPONSE\`).token" )

# Use the read token to find the ID number of the current Mac
COMPUTER_RECORD=$( /usr/bin/curl -s "${JSS_URL}api/v1/computers-inventory?section=USER_AND_LOCATION&filter=udid%3D%3D%22${HARDWARE_UDID}%22" -H "authorization: Bearer ${TOKEN}" )
ID=$( /usr/bin/osascript -l 'JavaScript' -e "JSON.parse(\`$COMPUTER_RECORD\`).results[0].id" )

echo "Jamf Computer ID: $id"

# Enable Remote Desktop
/usr/bin/curl -s "${JSS_URL}JSSResource/computercommands/command/EnableRemoteDesktop/id/$ID" -H "authorization: Bearer ${TOKEN}" -X POST

# Invalidate the token
/usr/bin/curl -s -k "${JSS_URL}api/v1/auth/invalidate-token" -H "authorization: Bearer ${TOKEN}" -X POST

#########################################################################################
# Configure Apple Remote Desktop
#########################################################################################

# Declare users with ARD access
ARD_USERS_LIST="admin1,admin2"

/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -users "${ARD_USERS_LIST}" -access -on -privs -all -restart -agent
    
exit 0