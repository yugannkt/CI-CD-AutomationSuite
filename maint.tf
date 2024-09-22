provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

# Create EC2 for Jenkins
module "jenkins_ec2" {
  source        = "./ec2"
  ami_id        = var.ami_id
  instance_type = var.jenkins_instance_type
  key_name      = var.key_name
  instance_name = "Jenkins"
  app_port      = var.jenkins_app_port
}

# Create EC2 for SonarQube
module "sonarqube_ec2" {
  source        = "./ec2"
  ami_id        = var.ami_id
  instance_type = var.sonarqube_instance_type
  key_name      = var.key_name
  instance_name = "SonarQube"
  app_port      = var.sonarqube_app_port
}

# Install Jenkins
module "Jenkins" {
  source                 = "./jenkins"
  jenkins_ec2_public_ip = module.jenkins_ec2.ec2_public_ip
}

# Install SonarQube
module "SonarQube" {
  source           = "./sonarqube"
  ec2_public_ip    = module.sonarqube_ec2.ec2_public_ip
}

# Write inventory file for Ansible
resource "local_file" "inventory" {
  content  = "[Jenkins]\n${module.jenkins_ec2.ec2_public_ip} ansible_user=ec2-user\n\n[Sonarqube]\n${module.sonarqube_ec2.ec2_public_ip} ansible_user=ec2-user\n"
  filename = "inventory.ini"
}

# Output the public IPs
output "jenkins_ec2_public_ip" {
  value = module.jenkins_ec2.ec2_public_ip
}

output "sonarqube_ec2_public_ip" {
  value = module.sonarqube_ec2.ec2_public_ip
}
