variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "resume_domain" {
  description = "Domain for CORS allow_origins"
  type        = string
  default     = "https://resume.miguelhorta.com"
}
