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


# Verify the proxy settings
echo "Verifying proxy settings..."
echo "HTTP Proxy: $http_proxy"
echo "HTTPS Proxy: $https_proxy"

# Start mitmdump in the background and redirect its output to a log file
echo "Starting mitmdump to handle HTTP and HTTPS traffic..."
mitmdump -p 8080 -s /home/app/sherlogs-client/interceptor.py 


