output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.requests.name
}

output "lambda_invoke_arn" {
  description = "Lambda function invoke ARN"
  value       = aws_lambda_function.health_check.invoke_arn
}

output "lambda_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.health_check.function_name
}

