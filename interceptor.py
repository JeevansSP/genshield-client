from mitmproxy import http

from typing import List, Union
import json

from concurrent.futures import ThreadPoolExecutor
from consumer import Consumer
from pprint import pprint
import uuid

from queue import Queue
from collections import defaultdict

implemnted_hosts: List[str] = [
    "api.openai.com/v1/chat/completions",
    "generativelanguage.googleapis",
]


def checkIfKnownRequest(url: str) -> Union[bool, str]:
    return next(filter(lambda h: (h in url), implemnted_hosts), False)


stream_responses = defaultdict(list)


consumer = Consumer()


def responseheaders(flow: http.HTTPFlow):

    if (
        "openai.com" in flow.request.pretty_host
        or "generativelanguage.googleapis" in flow.request.pretty_host
    ):
        content_type = flow.response.headers.get("Content-Type", "")

        if "text/event-stream" in content_type:
            flow.stream_id = str(uuid.uuid1())

            flow.response.stream = lambda chunks: stream_http_body(
                flow, chunks, "utf-8"
            )


def stream_http_body(flow, chunks: bytes, encoding: str):
    if flow.stream_id:
        stream_responses[flow.stream_id].append(chunks.decode(encoding=encoding))
    return chunks


def response(flow: http.HTTPFlow) -> None:
    url = flow.request.pretty_url

    host_type: Union[bool, str] = checkIfKnownRequest(url)
    if host_type is False:
        return

    consumer.q.put(
        {
            "url": url,
            "request_data": flow.request.json(),
            "response_data": (
                flow.response.json()
                if flow.response.stream is False
                else stream_responses[flow.stream_id]
            ),
            "is_stream": not flow.response.stream is False,
        }
    )

    if not flow.response.stream is False and stream_responses.get(flow.stream_id):
        del stream_responses[flow.stream_id]
