# import re
from multiprocessing.connection import Client
import requests
import json
import logging
import boto3

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

kinesis_client = boto3.client('kenesis', region_name='us-east-1')


WEB_ENDPOINT = 'https://61e67a17ce3a2d0017359174.mockapi.io/web-logs/web'


def _ingesting_web(endpoint):
    "This function will ingest raw data from endpoint without Authentication"
    try:
        res = requests.get(WEB_ENDPOINT)
        payload = json.loads(res.text)
        LOGGER.debug(f'Raw data: {payload}')

        # Put data to Kinesis Stream
        kinesis_client.put_records_batch(
            StreamName='web_raw_streaming', Data=payload)

    except Client:
        LOGGER.exception('Client Error')
    except ValueError:
        LOGGER.exception('Value Error')
    except Exception as e:
        LOGGER.exception(f'Ingestion failed with {e}')
