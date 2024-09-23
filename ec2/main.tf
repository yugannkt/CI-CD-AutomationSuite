resource "aws_security_group" "ec2_security_group" {
  name        = "${var.instance_name}-SSSG"
  description = "Allow inbound traffic for ${var.instance_name} instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (restrict in production)
  }

  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (restrict in production)
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open the app port
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = var.instance_name
  }
}

# resource "null_resource" "install" {

#   provisioner "local-exec" {
#     command = "terraform apply -target module.${var.instance_name}"
#   }
# }

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance."
  value       = aws_instance.ec2_instance.public_ip
}
