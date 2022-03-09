from unittest.mock import patch
from src.web_ingesting import lambda_handler
from data import data


MOCK_DATA = data

@patch.dict('os.environ', {
    'WEB_ENDPOINT': "https://mock-api.com/mock_data",
    'RAW_STREAM_NAME': 'mock_stream_name'
})
def test_lambda_handler():
    print(MOCK_DATA)
    resp = lambda_handler()
    assert resp.status_code == 200

