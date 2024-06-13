# SherLogs Client App

## Description

SherLogs is an innovative application designed to intercept and analyze network traffic between client applications and various LLM services like OpenAI and Google. This analysis helps ensure the safety and compliance of data exchanged. SherLogs utilizes MitmProxy, a versatile tool for inspecting, modifying, and decrypting HTTP and HTTPS traffic.

## Setup

### Installation

1. Clone the repository:
   `git clone https://github.com/JeevansSP/sherlogs-client`
2. Navigate to the project directory:
   `cd sherlogs-client`
3. Make sure python is installed by checking
   `python3 --version`
4. Run the installation script:
   `./install.sh`
This script will handle the installation of MitmProxy, configure your environment, and set up necessary certificates based on your operating system.

### Configuration and Running

4. Ensure your environment is configured to use the proxy:
- **Ubuntu**: Add the following to your sudoers file to preserve environment variables:
  ```
  Defaults env_keep += "http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"
  ```
- **macOS**: Set HTTP and HTTPS proxies to `http://localhost:8080` in Network Preferences wifi settings> Advanced > Proxies.

5. Start the application by running:
   `./run.sh <your_api_key>`
Replace `<your_api_key>` with your actual API key. This script sets the API key as an environment variable and starts MitmProxy to intercept traffic.  
Visit [Sherlogs](https://sherlogs.web.app) to generate an api key.

## Features

- Automatic interception and decryption of traffic using MitmProxy.
- Seamless integration with various LLM services without requiring specific frameworks.
- Detailed logging and analysis of intercepted data for compliance and safety checks.

## Certificate Installation

If you encounter any issues with HTTPS connections after setup, you may need to manually trust the MitmProxy certificate:
- Access the generated certificate at `~/.mitmproxy/mitmproxy-ca-cert.pem`.
- Follow the OS-specific instructions to install and trust the certificate in your system and Python environment.
  
If You are running python scripts in a virtual env you will have to append the mitm cert to your venv's certifi chain
   `cat /.mitmproxy/mitmproxy-ca-cert.pem >> <path_to_venv>/<venv_folder_name>/libs/python3.xx/site-packages/certifi/<certificate_bundle>.pem`

## Usage

To use SherLogs:
1. Ensure the proxy settings are correctly configured.
2. Run the script with your API key to start intercepting and analyzing LLM service traffic:
   `./run.sh your_api_key_here` (`nohup ./run.sh your_api_key_here  > /dev/null 2>&1 &` if you want to run it in the background)

## Additional Notes

- For detailed command usage and troubleshooting, refer to the comprehensive comments in the `install.sh` and `run.sh` scripts.
- Visit our support page for more help and FAQs about SherLogs setup and operations.

## Todo

- Implement interceptor logic for LLM services such as Ollama, Llama.cpp, HuggingFace, Anthropic, and Gorq. Most of these services follow an OpenAI-compatible pattern, and parsers for many are already implemented server-side.

