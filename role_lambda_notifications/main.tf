# Simple AWS Lambda Terraform Example
# requires 'index.js' in the same directory
# to test: run `terraform plan`
# to deploy: run `terraform apply`

variable "aws_region" {
  default = "us-west-2"
}

provider "aws" {
  region          = "${var.aws_region}"
}

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "bin/aws-lambda-go"
    output_path   = "lambda_function_go.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_go.zip"
  function_name    = "test_lambda_go"
  role             = "${aws_iam_role.iam_for_lambda_tf.arn}"
  handler          = "aws-lambda-go"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime          = "go1.x"
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id   = "AllowExecutionFromS3Bucket"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.test_lambda.arn}"
  principal      = "s3.amazonaws.com"
  source_arn     = "${aws_s3_bucket.foo.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.foo.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.test_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = ["aws_lambda_permission.allow_bucket"]
}

resource "aws_iam_role_policy_attachment" "aws_managed_policy" {
  role       = "${aws_iam_role.iam_for_lambda_tf.name}"
#  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "aws_managed_policy_s3" {
  role       = "${aws_iam_role.iam_for_lambda_tf.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
