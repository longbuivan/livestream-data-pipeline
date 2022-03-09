from typing import Tuple
from unittest.mock import patch, call
import pytest
from freezegun import freeze_time
from src.flatting_data import lambda_handler, _event_parser, _put_kinesis_data_stream


def test_lambda_handler():
    assert True


def test_event_parser():
    assert True


def test_put_kinesis_data_stream():
    assert True
