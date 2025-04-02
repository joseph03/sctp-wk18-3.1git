terraform {
  backend "s3" {
    bucket = "joseph-sctps3bucket"  # "sctp-ce9-tfstate"
    key    = "joseph03-wk18-3.1"  
    region = "us-east-1"
  }
}
