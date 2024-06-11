#!/bin/bash

# Check if API key is provided as a command line argument
if [ "$#" -ne 1 ]; then
    echo "kindly provide the API key as an argument."
    exit 1
fi

# Assign the API key to a variable
api_key="$1"

# Set the API key as an environment variable
export SHERLOGS_API_KEY="$api_key"
echo "SHERLOGS_API_KEY set to $SHERLOGS_API_KEY"


# Set up system-wide proxy settings for HTTP and HTTPS


# Append proxy settings to .profile to ensure they persist after reboot


# For sudo commands to keep proxy settings
sudo sed -i '/# Defaults env_keep += "http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"/s/^# //g' /etc/sudoers

# Verify the proxy settings
echo "Verifying proxy settings..."
echo "HTTP Proxy: $http_proxy"
echo "HTTPS Proxy: $https_proxy"

# Start mitmdump in the background and redirect its output to a log file
echo "Starting mitmdump to handle HTTP and HTTPS traffic..."
mitmdump -p 8080 -s /home/app/sherlogs-client/interceptor.py 

# MITMDUMP_PID=$!
# echo "mitmdump is running with PID $MITMDUMP_PID, logging to mitmdump.log."

# echo "Setup is complete and system proxy settings are applied."
