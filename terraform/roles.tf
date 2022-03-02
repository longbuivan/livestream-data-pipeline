resource "aws_iam_role" "lambda_sorter_role" {
  name               = "lambda-sorter-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
  role       = aws_iam_role.lambda_sorter_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_kinesis_execution" {
  role       = aws_iam_role.lambda_sorter_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}


resource "aws_iam_role_policy" "lambda_kinesis_put_record" {
  name   = "lambda-kinesis-put-record"
  role   = aws_iam_role.lambda_sorter_role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LambdaPutRecordtoFirehose",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Effect": "Allow",
            "Resource": [
                "${aws_kinesis_firehose_delivery_stream.data_delivery_stream_s3.arn}"
            ]
            }
    ]
}
EOF
}
