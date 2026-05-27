data "aws_caller_identity" "current" {}

# --- Lambda Function ---

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/func.py"
  output_path = "${path.module}/lambda/func.zip"
}

resource "aws_lambda_function" "visitor_counter" {
  filename         = data.archive_file.zip_the_python_code.output_path
  source_code_hash = data.archive_file.zip_the_python_code.output_base64sha256
  function_name    = "cloud-resume-visitor-counter"
  role             = aws_iam_role.lambda_role.arn
  handler          = "func.lambda_handler"
  runtime          = "python3.12"
  timeout          = 10
}

# --- Lambda Function URL ---

resource "aws_lambda_function_url" "visitor_counter_url" {
  function_name      = aws_lambda_function.visitor_counter.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = [var.resume_domain]
    allow_methods     = ["GET"]
    allow_headers     = ["content-type"]
    expose_headers    = ["date"]
    max_age           = 86400
  }
}

# --- IAM Role & Policy ---

resource "aws_iam_role" "lambda_role" {
  name = "cloud-resume-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "cloud-resume-lambda-policy"
  description = "IAM policy for the cloud resume visitor counter Lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/MH-resume"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# --- Outputs ---

output "lambda_function_url" {
  description = "URL for the visitor counter Lambda"
  value       = aws_lambda_function_url.visitor_counter_url.function_url
}
