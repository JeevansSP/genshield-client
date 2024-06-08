from queue import Queue
from concurrent.futures import ThreadPoolExecutor
from threading import Thread
import requests


import os

api_key = os.environ.get("SHERLOGS_API_KEY")

api_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlfa2V5X2lkIjoyLCJtb2RlIjoiYWNjZXNzX3Rva2VuIiwibmFtZSI6ImxvY2FsIn0.9c4LEnZkYvgTV78QWUuzWfhMr0IN6_tcP_pSSLBP61U"


sherlogs_endpoint = "http://localhost:8000/raw/log"


class Consumer:
    def __init__(
        self,
    ):
        self.q = Queue()
        self.consumer_end_point = ""
        Thread(target=self.runExecutor, daemon=True).start()

    def consume(self, data: dict):
        print("Consuming data...")
        print(data)
        try:
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
            print(response.json())
        except Exception as e:
            print(e)

    def runExecutor(
        self,
    ):
        with ThreadPoolExecutor(max_workers=5) as executor:
            while True:
                data = self.q.get()

                executor.submit(self.consume, data)
                self.q.task_done()
