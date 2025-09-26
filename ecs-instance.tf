# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "dev_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.medium"
  subnet_id                   = aws_subnet.public-subnet-a.id
  key_name                    = "Jenkins-Key"
  vpc_security_group_ids      = [aws_security_group.ecs_sg.id]
  associate_public_ip_address = true

  user_data = file("command.sh")

  tags = {
    Name = "Dev-Server"
  }
}
