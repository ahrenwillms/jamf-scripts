#!/usr/local/bin/python3

# Requires Python 3 and requests module to be installed

import requests
import json
import subprocess

# Get computer serial number from system_profiler command
system_profile_data = subprocess.Popen(
    ['system_profiler', '-json', 'SPHardwareDataType'], stdout=subprocess.PIPE)
data = json.loads(system_profile_data.stdout.read())
serial_number = data.get('SPHardwareDataType', {})[0].get('serial_number')

print("Serial number is: %s" %serial_number)

# Log in to FileMaker Server 
login_url = 'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/sessions'
login_headers = {'Content-Type': 'application/json'}
login_result = requests.post(login_url, headers=login_headers, auth=('USERNAME', 'PASSWORD'))

login_response = login_result.json()
token = login_response["response"]["token"]

query_data = {
    "query":[
        {"Assets::hardware_serial_number": serial_number}
        ]
    }

# Search FileMaker database for serial number
query_url = 'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/layouts/LAYOUT_NAME/_find'
query_headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer %s' %token}
query_result = requests.post(query_url, headers=query_headers, json=query_data)

query_response = query_result.json()
computer_name = query_response["response"]["data"][0]["fieldData"]["computer_name"]

print("Computer name from FileMaker Server is: %s" %computer_name)

# Log out of FileMaker Server
logout_url = 'https://FILEMAKER_SERVER_URL/fmi/data/v1/databases/DATABASE_FILE_NAME/sessions/%s' %token
logout_result = requests.delete(logout_url, data='')

# Update local computer name with scutil commands
try:
    scutil_local_host_name = subprocess.check_output(["sudo", "scutil", "--set", "LocalHostName", computer_name])
except subprocess.CalledProcessError as e:
    print(e.output)
try:
    scutil_computer_name = subprocess.check_output(["sudo", "scutil", "--set", "ComputerName", computer_name])
except subprocess.CalledProcessError as e:
    print(e.output)
try:
    scutil_host_name = subprocess.check_output(["sudo", "scutil", "--set", "HostName", computer_name])
except subprocess.CalledProcessError as e:
    print(e.output)