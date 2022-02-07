resource "aws_lambda_event_source_mapping" "kinesis_lambda_triggering" {
  event_source_arn                   = aws_kinesis_stream.web_raw_streaming.arn
  function_name                      = aws_lambda_function.flatting_data.arn
  starting_position                  = "LATEST"
  enabled                            = true
  batch_size                         = var.kinesis_lambda_trigger_config["config"]["batch_size"]
  maximum_batching_window_in_seconds = var.kinesis_lambda_trigger_config["config"]["maximum_batching_window_in_seconds"]
  parallelization_factor             = var.kinesis_lambda_trigger_config["config"]["parallelization_factor"]
  maximum_record_age_in_seconds      = var.kinesis_lambda_trigger_config["config"]["maximum_record_age_in_seconds"]
  maximum_retry_attempts             = var.kinesis_lambda_trigger_config["config"]["maximum_retry_attempts"]


  destination_config {
    on_failure {
      destination_arn = aws_sns_topic.ovw_lambda_sorter_dlq_sns.arn
    }
  }
}
