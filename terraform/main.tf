resource "aws_dynamodb_table" "requests" {
    name = "${var.env}-requests-db"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "request_id"
    attribute {
        name = "request_id"
        type = "S"
      
    }
  
}