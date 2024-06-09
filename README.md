# SherLogs Client App

## Description

SherLogs is a unique application designed to capture logs from various LLM service applications without locking you into specific frameworks, unlike some current tools (such as LangSmith). SherLogs intercepts text generation and chat completion requests and responses from all known LLM services and conducts safety checks by forwarding this data to our servers for analysis.

This app leverages [MitmProxy](https://mitmproxy.org/), a powerful tool used to analyze and modify HTTP/HTTPS network traffic by acting as a man-in-the-middle (MITM) agent. The structure of the network interaction follows this pattern:  
 `   client <-> mitm <-> server  
  `

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

### Configuration and Running

6. Start the MitmProxy server in headless mode on port 8080, listening to ports 80 and 443:  
   `mitmproxy -p 8080`

7. Initially, any web connections from browsers will fail due to the lack of a trusted certificate.

### Certificate Installation

8. Visit `http://mitm.it` to download the appropriate certificate.
9. Follow the installation guides for your system:

- [Mac](https://www.youtube.com/watch?v=7BXsaU42yok&t=525s)
- [Windows](https://www.youtube.com/watch?v=AacH2L_D2B8)
- [Linux](https://www.youtube.com/watch?v=igcsLKDfssw) 
- it all boils down to these steps:
    1. enable http/https proxy in the system and point it to `http://localhost:8080`
    2. add `mitmproxy-ca-cert.pem` into the system's trusted ca bundle
    3. append the same cert to the python packages `certifi`'s `cacert.pem` file
    4. In ubuntu the cert is generated in `~/.mitmproxy` after it has been run for a while
    5. `export http_proxy="http://localhost:8080"` wont persist when using sudo unless you modify the `visudo` file


10. Append the downloaded `mitm-proxy-ca-cert.pem` to your local Python environment's certifi package:

```
cat path/to/mitm-proxy-ca-cert.pem >> env/lib/python3.12/site-packages/certifi/cacert.pem
```

Optionally, append it to the global certifi package by locating `cacert.pem` and performing a similar operation.

### Starting the App

11. Register and generate an API key at
    `https://sherlogs.cydratech.com`.
12. Export the API key in your current shell session:

```
export SHERLOGS_API_KEY="<your_api_key>"
```

13. Run the SherLogs start script:

```
./startSherlogs.sh
```

## Features

- Interception and logging of text-to-text API services from Google and OpenAI to the SherLogs server.
- Frameworks like CrewAI and LangChain that build on these REST API services are also supported.

## Todo

- Implement interceptor logic for LLM services such as Ollama, Llama.cpp, HuggingFace, Anthropic, and Gorq. Most of these services follow an OpenAI-compatible pattern, and parsers for many are already implemented server-side.
- Address the challenge of intercepting Google's generative AI package which utilizes `gRPC` for their Gemini calls.
