resource "aws_instance" "web" {
  ami = var.ami_id
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.sg
  instance_type = var.ec2_type
  associate_public_ip_address = var.associate_public_ip
  key_name = var.key_pair
  user_data = file("${path.module}/userdata.sh")
  tags = {
    Name = "${var.instance_name}-${var.environment}"
    Environment = var.environment
  }
}

#one template for many servers.....


