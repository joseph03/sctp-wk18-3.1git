data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

# my local machine's public ip
# used this in security group of public ec2
# That allows my laptop to SSH into all 3 EC2s — because they all share this security group.
locals {
  my_ip_cidr = "${chomp(data.http.my_ip.body)}/32"   
}
