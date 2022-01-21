"""Parsing json to csv and parquet"""
import os
import logging
import json
import csv
from datetime import datetime
import boto3

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

dynamodb_client = boto3.client('dynamodb', region_name='us-east-1')
s3_client= boto3.client('s3', region_name='us-east-1')
firehose_client = boto3.client('firehose', region_name='us-east-1')

LAMBDA_PATH = "/tmp/"
DST_BUCKET_2 = 'bucket-2-csv'
DST_BUCKET_3 = 'json-to-parquet-stream'
COUNTING_TABLE = 'counting-table'


def _read_json_object(event):
    """Read json object files"""
    bucket = event['Records'][0]['s3']['bucket']['name']
    json_file_name = event['Records'][0]['s3']['object']['key']
    json_object = s3_client.get_object(Bucket = bucket, Key = json_file_name)
    json_object_reader = json_object['Body'].read()
    return json.loads(json_object_reader)

def _auto_generate_dynamodb():
    """Generate a incremental key value"""
    response = dynamodb_client.get_item(
        TableName = COUNTING_TABLE,
        Key = { 'Key':
            {'S' : 'Counter'}
        }
    )
    new_key = 0
    if response.get('Item'):
        curr_key = int(response['Item']['TotalCount']['N'])
        new_key = curr_key + 1
        dynamodb_client.put_item(
            TableName = COUNTING_TABLE,
            Item={
                'Key': {
                    'S' : 'Counter'
                },
                'TotalCount' : {
                    'N' : str(curr_key + 1)
                }
            }
        )
    else:
        dynamodb_client.put_item(
            TableName = COUNTING_TABLE,
            Item={
                'Key': {
                    'S' : 'Counter'
                },
                'TotalCount' : {
                    'N' : str(0)
                }
            }
        )
    return new_key

def _json_to_csv(json_data):
    """Write record from json file to csv file in the destination bucket"""
    try:
        with open(LAMBDA_PATH + "data.csv", "w", encoding = 'utf-8') as file:
            csv_file = csv.writer(file)
            csv_file.writerow(['index','LocationID','Name','CostRate',
            'Availability','ModifiedDate'])
            for item in json_data:
                csv_file.writerow([item.get('index'),item.get('LocationID'),item.get('Name'),
                item.get('CostRate'),item.get('Availability'),item.get('ModifiedDate')])
    except KeyError:
        LOGGER.exception("Cannot convert to csv files")
    filename = datetime.now().strftime('%Y/%m/%d/%H-%M-%S.csv')
    with open(LAMBDA_PATH + 'data.csv', 'rb') as data:
        s3_client.put_object(Bucket= DST_BUCKET_2, Body = data, Key = filename)
    os.remove(LAMBDA_PATH + 'data.csv')
    return filename

def _json_to_parquet(json_data):
    responses = []
    for item in json_data:
        response = firehose_client.put_record(
            DeliveryStreamName = DST_BUCKET_3,
            Record={
                'Data': json.dumps(item)
            }
        )
        responses.append(response)
    return responses

def lambda_handler(event, context):
    """Main function"""
    LOGGER.info('Event structure: %s', event)
    json_data = _read_json_object(event)
    LOGGER.info("File json to csv processed: " + str(_json_to_csv(json_data)))
    LOGGER.info("File json to parquet: " + str(_json_to_parquet(json_data)))
    LOGGER.info("New key: " + str(_auto_generate_dynamodb()))
