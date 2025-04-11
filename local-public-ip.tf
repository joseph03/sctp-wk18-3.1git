data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

# variable is used instead of local because
# when terraform is run in my machine, then the value is
# my local machine's public ip 
# if terraform is run by github workflow, then the value is 
# github's public ip
# used this in security group of public ec2
# That allows my laptop to SSH into all 3 EC2s — because they all share this security group.
variable "my_ip_cidr" {
  type        = string
  description = "Public IP address of the machine running Terraform"
  default     = "${chomp(data.http.my_ip.body)}/32"
}
#locals {
#  my_ip_cidr = "${chomp(data.http.my_ip.body)}/32"   
#}

