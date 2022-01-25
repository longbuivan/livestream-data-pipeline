resource "aws_kinesis_stream" "web_raw_streaming" {
  name             = "web_raw_streaming"
  shard_count      = 1
  retention_period = 12

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "OutgoingRecords",
    "IncomingRecords"
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = local.tags
}