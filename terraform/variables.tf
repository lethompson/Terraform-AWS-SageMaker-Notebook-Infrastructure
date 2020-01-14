# Default Tags
variable "default_resource_group" {
  description = "Default value to be used in resources' Group tag."
  default     = "deep-racer-model"
}

variable "default_created_by" {
  description = "Default value to be used in resources' CreatedBy tag."
  default     = "terraform"
}

# AWS Settings
variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "LennoxT"
}

# Parameters
variable "function_bucket_name" {
  description = "Name of the S3 bucket hosting the code for deep_racer Lambda function."
}

variable "function_version" {
  description = "Version of the deep_racer Lambda function to use."
}

variable "s3_bucket_name_1" {
  description = "New bucket for storing the Amazon SageMaker model and training data."
}

variable "s3_bucket_name_2" {
  description = "New bucket for storing processed events for visualization features."
}

