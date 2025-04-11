resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id] # Updated SG
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from AZ us-east-1${["a", "b", "c"][count.index]}" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
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

resource "aws_security_group" "public_ec2_sg" {
  vpc_id = aws_vpc.main.id
  name   = "${local.name_prefix}public-ec2-sg"

  # Allow HTTP from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Restrict to ALB only
  }

  # Allow SSH from your IP (replace 1.2.3.4/32 with your IP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 1.2.3.4/32. Restrict to your IP for security. how?
  }

  # Allow ALL outbound traffic (for yum/SSH forwarding)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}public-ec2-sg"
  }
}

resource "aws_instance" "private" {
  count         = 2
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id] # Updated SG
  tags = {
    Name = "${local.name_prefix}private-${count.index}"
  }
}

resource "aws_security_group" "private_ec2_sg" {
  vpc_id = aws_vpc.main.id
  name   = "${local.name_prefix}private-ec2-sg"

  # Allow SSH only from public EC2 instances
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ec2_sg.id] # Restrict to public EC2 SG
  }

  # Allow ALL outbound traffic (for updates/SSH)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}private-ec2-sg"
  }
}