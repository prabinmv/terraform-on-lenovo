terraform {
  backend "s3" {
    bucket = "tfstate.terraform.bucket"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}
