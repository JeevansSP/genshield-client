## SherLogs client app

#### Description

Currently there is no other app on the market to capture your LLM service application logs, the existing toold lock you into certain frameworks (im looking at you langsmith)  
SherLogs captures all known LLM service text generation/chat completion request response and performs a safety check by sending it to our serers.
This app is built upon a known tool called [MitmProxy](https://mitmproxy.org/). This is a tool that is used to analyze/modify http/https network traffic by acting as man in the middle agent. Any http/https request sent from/to the system will go through this tool.  
`client <-> mitm <-> server`  
The server to which client want to send the request thinks the request is comming from mitm hence the response from the server can only be de-crypted by mitm  
and when the client receives the request it will flag it as insecure and be unable to decrypt it. To solve this we need to add the mitm certificate into the trusted certifacte bundle.

#### Setup

1. clone this repo `git clone https://github.com/JeevansSP/sherlogs-client`
2. cd into the project folder
3. create a virtual env (not optional and recommended): `python -m venv env`
4. activate virtual env
   - windows: `.\env\Source\activate`
   - mac or linux: `source .\env\bin\activate`
5. Install needed packages `pip install -r ./requirements.txt`
6. Run the `mitmproxy` script, this will start the mitmproxy server in headless mode in port 8080 listening to 80 and 443 ports of the system
7. Now if you try to connect to the web on any browser you will fail.
8. To solve this we need to add the mitm cert into the system's trusted cert bundle
9. head over to `http://mitm.it` and download the certificate of your choice
10. certificate installation tutorial for [mac](https://www.youtube.com/watch?v=7BXsaU42yok&t=525s), [windows](https://www.youtube.com/watch?v=AacH2L_D2B8) and [linux](https://www.youtube.com/watch?v=igcsLKDfssw)
11. Now we need to make your python requests module also trust the mitm cert. The cert downlaoded from `mitm.it` would have the name `mitm-proxy-ca-cert.pem`, you need to append to end of the `env/lib/python3.12/site-packages/certifi/cacert.pem`, if you want to install it on your global certifi python package, go ahead and locate it and append the same.
12. Now finally before you can run `startSherlogs.sh` script kindlt headover to `https://sherlogs.cydratech.com` and create an api key to use
13. export the api key in your current shell session `export SHERLOGS_API_KEY="<your_api_key"`.
14. Run `startSherlogs.sh`

#### Features
- currently only `google` and `openai` text to text api services will be intercepted and logged to sherlogs server
- Since `crewai`, `langchain` and other frameworks rae built on top of these REST API calls, you can bet those requests will also be intercepted.


#### TODO
- Implemented interceptor logic for `ollama`, `llama.cpp`, `huggingface`, `anthropic` and `gorq`, thankfully since most of them follow openai compatible pattern, parsers for most of these are already implemented on the server
- google generativeai pacakge has implemnted their gemini calls using `gRPC`, figure out a way to intercept.





