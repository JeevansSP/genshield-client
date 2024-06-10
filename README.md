# SherLogs Client App

## Description

SherLogs is a unique application designed to capture logs from various LLM service applications without locking you into specific frameworks, unlike some current tools (such as LangSmith). SherLogs intercepts text generation and chat completion requests and responses from all known LLM services and conducts safety checks by forwarding this data to our servers for analysis.

This app leverages [MitmProxy](https://mitmproxy.org/), a powerful tool used to analyze and modify HTTP/HTTPS network traffic by acting as a man-in-the-middle (MITM) agent. The structure of the network interaction follows this pattern:  
 `   client <-> mitm <-> server  `

The server perceives that requests come directly from MitmProxy, which means it can decrypt the responses intended for the client. To ensure the client can also decrypt these intercepted communications securely, we need to add the MitmProxy certificate to the system’s trusted certificate bundle.

## Setup

### Installation

1. Clone the repository:  
   `git clone https://github.com/JeevansSP/sherlogs-client`
2. Change to the project directory:  
   `cd sherlogs-client`
3. Create a virtual environment (mandatory):  
   `python -m venv env`
4. Activate the virtual environment:

   - **Windows**:
     ```
     .\env\Scripts\activate
     ```
   - **Mac/Linux**:
     ```
     source env/bin/activate
     ```

5. Install the required packages:  
   `pip install -r requirements.txt`

6. Run the installation script to install `mitmproxy` and set up certificates:
   `sudo ./install_mitmproxy.sh`

### Running

1. Register and generate an API key at `https://sherlogs.cydratech.com`.

2. Export the API key in your current shell session:

3. Run the SherLogs start script to set up the proxy and start `mitmdump`:
   `run.sh "<your_api_key>"`


## Features

- Interception and logging of text-to-text API services from Google and OpenAI to the SherLogs server.
- Frameworks like CrewAI and LangChain that build on these REST API services are also supported.

## Todo

- Implement interceptor logic for LLM services such as Ollama, Llama.cpp, HuggingFace, Anthropic, and Gorq. Most of these services follow an OpenAI-compatible pattern, and parsers for many are already implemented server-side.
- Address the challenge of intercepting Google's generative AI package which utilizes `gRPC` for their Gemini calls.
- Based on your os you might have to manually set up `http_proxy` and `https_proxy` to `http://localhost:8080` 


