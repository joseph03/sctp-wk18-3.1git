provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "joseph03-wk18-3.1" # add 'a' to use terraform apply 
    region = "us-east-1"
  }
}
