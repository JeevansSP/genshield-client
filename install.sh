#!/bin/bash

# exec 1>logfile.txt 2>&1

# Install mitmproxy based on the OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Installing mitmproxy on Ubuntu..."
    sudo apt-get update
    sudo apt-get install -y mitmproxy
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Installing mitmproxy on macOS..."
    brew install mitmproxy
else
    echo "Unsupported OS"
    exit 1
fi

pip install mitmproxy

# Run mitmdump in the background to generate the certificate and not require a TTY
echo "Running mitmdump to generate certificates..."
mitmdump -p 8080 &
MITMPROXY_PID=$!

# Wait for mitmdump to initialize
sleep 5

# Use curl to hit google.com to initiate certificate generation
echo "Accessing google.com to ensure certificate generation..."
curl -x http://localhost:8080 https://google.com

# Stop mitmdump
echo "Stopping mitmdump..."
kill $MITMPROXY_PID

# Process for installing certificates as before
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux/Ubuntu
    echo "Installing certificate on Ubuntu..."
    sudo mkdir -p /usr/local/share/ca-certificates/
    sudo cp ~/.mitmproxy/mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.crt
    sudo update-ca-certificates

    # Append to Python's certifi package store
    CERT_FILE=$(python3 -m certifi)
    cat ~/.mitmproxy/mitmproxy-ca-cert.pem | sudo tee -a $CERT_FILE
    echo "# Defaults env_keep += \"http_proxy https_proxy HTTP_PROXY HTTPS_PROXY\"" | sudo tee -a /etc/sudoers

    echo "export http_proxy=\"http://localhost:8080\"" >> ~/.profile
    echo "export https_proxy=\"http://localhost:8080\"" >> ~/.profile
    echo "export HTTP_PROXY=\"http://localhost:8080\"" >> ~/.profile
    echo "export HTTPS_PROXY=\"http://localhost:8080\"" >> ~/.profile


elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Installing certificate on macOS..."
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.mitmproxy/mitmproxy-ca-cert.pem

    # Append to Python's certifi package store
    CERT_FILE=$(python3 -m certifi)
    cat ~/.mitmproxy/mitmproxy-ca-cert.pem | sudo tee -a $CERT_FILE

else
    echo "Unsupported OS"
    exit 1
fi


echo "Setup complete!"
