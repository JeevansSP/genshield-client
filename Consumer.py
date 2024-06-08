from queue import Queue
from concurrent.futures import ThreadPoolExecutor
from threading import Thread
import requests


import os


api_key = os.environ.get("SHERLOGS_API_KEY")

if not api_key:
    raise KeyError("please provide a valid api key")

sherlogs_endpoint = "http://localhost:8000/raw/log"


class Consumer:
    def __init__(
        self,
    ):
        self.q = Queue()
        self.consumer_end_point = ""
        Thread(target=self.runExecutor, daemon=True).start()

    def consume(self, data: dict):
        headers = {"Authorization": f"Bearer {api_key}"}
        response = requests.post(
            sherlogs_endpoint,
            json={
                "url": data["url"],
                "request_data": data["request_data"],
                "response_data": data["response_data"],
                "is_stream": data["is_stream"],
            },
            headers=headers,
        )
        if response.status_code not in {200, 201}:
            print(f"Failed to send data to sherlogs: {response.text}")

    def runExecutor(
        self,
    ):
        with ThreadPoolExecutor(max_workers=5) as executor:
            while True:
                data = self.q.get()

                executor.submit(self.consume, data)
                self.q.task_done()
