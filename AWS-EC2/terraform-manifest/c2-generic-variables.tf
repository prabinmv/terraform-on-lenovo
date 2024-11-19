variable "aws_region" {
  description = "AWS Region"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Environment variabale used as prefix"
  type = string
  default = "dev"
}

variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "sap"
}