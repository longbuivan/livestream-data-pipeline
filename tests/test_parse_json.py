from typing import Tuple
from unittest.mock import patch, call
import json
import base64
import time
import pytest
from freezegun import freeze_time
from src.flatting_data import lambda_handler, _read_json_object, _auto_generate_dynamodb, _json_to_csv, _json_to_parquet


def test_lambda_handler():
    assert True


def test_read_json_object():
    assert True


def test_auto_generate_dynamodb():
    assert True


def test_json_to_csv():
    assert True


def test_json_to_parquet():
    assert True
