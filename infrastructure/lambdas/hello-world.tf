data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "hello_world" {
  filename         = "hello_world.zip"
  function_name    = "hello-world"
  role             = "arn:aws:iam::${data.aws_caller_identity.current_east.account_id}:role/${var.role_name}"
  handler          = "hello_world.handler"
  runtime          = "python3.7"
  source_code_hash = "${base64sha256(file("hello_world.zip"))}"
  timeout          = 15
  memory_size      = 128
  publish          = true
}

output "hello_world_lambda_arn" {
  value = "${aws_lambda_function.hello_world.arn}"
}

output "hello_world_lambda_version" {
  value = "${aws_lambda_function.hello_world.version}"
}
