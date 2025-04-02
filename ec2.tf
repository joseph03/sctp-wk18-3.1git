resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from AZ us-east-1${["a", "b", "c"][count.index]}" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              EOF

  tags = {
    Name = "${local.name_prefix}web-${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = 3
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}