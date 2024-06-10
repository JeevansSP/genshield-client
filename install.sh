#!/bin/bash

# Install mitmproxy
echo "Installing mitmproxy..."
pip install mitmproxy

# Run mitmproxy in the background to generate the certificate
echo "Running mitmproxy to generate certificates..."
mitmproxy -p 8080 &

MITMPROXY_PID=$!

# Wait for mitmproxy to initialize
sleep 5

# Use curl to hit google.com to initiate certificate generation
echo "Accessing google.com to ensure certificate generation..."
curl -x http://localhost:8080 https://google.com

# Stop mitmproxy
echo "Stopping mitmproxy..."
kill $MITMPROXY_PID

# Install mitmproxy certificate to the system's trusted CA bundle and Python's certifi package
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux/Ubuntu
    echo "Installing certificate on Ubuntu..."
    sudo mkdir -p /usr/local/share/ca-certificates/
    sudo cp ~/.mitmproxy/mitmproxy-ca-cert.pem /usr/local/share/ca-certificates/mitmproxy.crt
    sudo update-ca-certificates

    # Append to Python's certifi package store
    CERT_FILE=$(python -m certifi)
    cat ~/.mitmproxy/mitmproxy-ca-cert.pem | sudo tee -a $CERT_FILE

elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    echo "Installing certificate on macOS..."
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ~/.mitmproxy/mitmproxy-ca-cert.pem

    # Append to Python's certifi package store
    CERT_FILE=$(python -m certifi)
    cat ~/.mitmproxy/mitmproxy-ca-cert.pem | sudo tee -a $CERT_FILE
else
    echo "Unsupported OS"
fi

echo "Setup complete!"
