output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.requests.name
}
