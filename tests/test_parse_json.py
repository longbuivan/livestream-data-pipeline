from unittest.mock import patch, call
import json
import base64
import time
from botocore.exceptions import ClientError
import pytest
from freezegun import freeze_time
from src.parse_json import lambda_handler

def test_lambda_handler():
    assert True