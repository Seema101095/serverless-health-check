resource "aws_dynamodb_table" "requests" {
    name = "${var.env}-requests-db"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "request_id"
    attribute {
        name = "request_id"
        type = "S"
      
    }
  
}
# # 1. IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.env}-health-lambda-role"
  assume_role_policy = jsonencode({
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
  })
}
resource "aws_iam_role_policy" "lambda_policy" {
    role = aws_iam_role.lambda_role.id
    policy = jsonencode({
    Version = "2012-10-17", 
    Statement = [
     { Effect = "Allow", 
    Action = ["dynamodb:PutItem"], 
    Resource = aws_dynamodb_table.requests.arn 
    }, 
    { Effect = "Allow"
    Action = [ 
        "logs:CreateLogGroup", 
        "logs:CreateLogStream", 
        "logs:PutLogEvents" ], 
    Resource = "*" 
    }
    ]
    })
  
}



