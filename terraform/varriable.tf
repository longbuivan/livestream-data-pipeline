variable "AWS_REGION" {
  default = "ap-southeast-1"
}

variable "web_data_endpoint" {
  name = "https://61e67a17ce3a2d0017359174.mockapi.io/web-logs/web"
}

variable "kinesis_lambda_trigger_config" {
  default = {
    config = {
      "batch_size"                         = 10
      "maximum_batching_window_in_seconds" = 300
      "parallelization_factor"             = 2
      "maximum_record_age_in_seconds"      = 600
      "maximum_retry_attempts"             = 0
    }
  }
}
