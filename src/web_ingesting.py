# import re
from distutils.log import Log
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
        LOGGER.debug(f'Calling endpoint')
        res = requests.get(endpoint)
        payload = json.loads(res.text)
        LOGGER.debug(f'Raw data: {payload}')


        # Adding PartitionKey
        LOGGER.debug(f'Adding Partition key for data objects')



        # Put data to Kinesis Stream
        LOGGER.debug(f'Putting reccords')
        # kinesis_client.put_records(
        #     StreamName='web_raw_streaming', Records =payload)

    except Client:
        LOGGER.exception('Client Error')
    except ValueError:
        LOGGER.exception('Value Error')
    except Exception as e:
        LOGGER.exception(f'Ingestion failed with {e}')


def _lambda_handler(event, context):
    endpoint = WEB_ENDPOINT
    LOGGER.debug(f'Starting to pull data from endpoint')
    _ingesting_web(endpoint)

    # Todo:
    # 1. Failed handler
    # 2. Disaster Recovery