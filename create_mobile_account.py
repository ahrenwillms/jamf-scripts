#!/usr/local/bin/python3

#########################################################################################
# Script to create a mobile account based on the user assigned to the machine
# Requires Python 3 and requests module to be installed
#########################################################################################

import sys
import requests
import json
import subprocess

# Get computer serial number from system_profiler command
system_profile_data = subprocess.Popen(
    ['system_profiler', '-json', 'SPHardwareDataType'], stdout=subprocess.PIPE)
data = json.loads(system_profile_data.stdout.read())
serial_number = data.get('SPHardwareDataType', {})[0].get('serial_number')

print(f"Serial number is: {serial_number}")

#########################################################################################
# Query FileMaker Data API and store username and password as result
#########################################################################################

# Log in to FileMaker Server
login_url = 'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/sessions'
login_headers = {'Content-Type': 'application/json'}
login_result = requests.post(login_url, headers=login_headers, auth=('USERNAME', 'PASSWORD'))

login_response = login_result.json()
token = login_response["response"]["token"]

query_data = {
    "query":[
        {"Assets::hardware_serial_num": serial_number}
        ]
    }

# Search FileMaker database for serial number
query_url = 'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/layouts/LAYOUT_NAME/_find'
query_headers = {'Content-Type': 'application/json', 'Authorization': f'Bearer {token}'}
query_result = requests.post(query_url, headers=query_headers, json=query_data)

# Convert the result to JSON
query_response = query_result.json()

# Store field data as variables
computer_name = query_response["response"]["data"][0]["fieldData"]["computer_name"]
username = query_response["response"]["data"][0]["fieldData"]["Users::username"]
password = query_response["response"]["data"][0]["fieldData"]["Users::current_password"]
status = query_response["response"]["data"][0]["fieldData"]["status"]

# Print value(s) for debugging
print(f"Computer name from FileMaker Server is: {computer_name}")

# Log out of FileMaker Server
logout_url = f'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/sessions/{token}'
logout_result = requests.delete(logout_url, data='')

#########################################################################################
# Spawn process to create a mobile account for the user assigned to the machine
#########################################################################################

if status == "Assigned":
	create_mobile_account = subprocess.Popen(["sudo", "/System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount", "-n", username, "-p", password, "-D", "-v"])
	# Store command result as a variable
	create_account_result = create_mobile_account.communicate()[0]
	# Print command output for created user
	print(create_account_result)
else:
	print("Computer is not assigned. Skipping account creation")

sys.exit(0)