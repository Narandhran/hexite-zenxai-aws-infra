terraform {
  backend "s3" {
    bucket = "zenxai-tf-state-bckt"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
  }
}
