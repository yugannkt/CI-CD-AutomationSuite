terraform {
  required_providers {
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

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
  content  = "[Jenkins]\n${module.jenkins_ec2.ec2_public_ip} ansible_user=ubuntu public_ip=${module.jenkins_ec2.ec2_public_ip}\n\n[Sonarqube]\n${module.sonarqube_ec2.ec2_public_ip} ansible_user=ubuntu public_ip=${module.sonarqube_ec2.ec2_public_ip}\n"
  filename = "${path.module}/ansible_script/inventory.ini"
}

# # Run Ansible playbook for SonarQube setup
# resource "ansible_playbook" "sonarqube_setup" {
#   name     = "SonarQube Setup"
#   playbook = "./ansible_script/sonarqube_setup.yml"

#   args = [
#     "-i", "${local_file.inventory.filename}",  # Use the inventory file
#     "--extra-vars", "jenkins_public_ip=${module.jenkins_ec2.ec2_public_ip}"  # Pass Jenkins IP as extra var
#   ]

#   depends_on = [module.sonarqube_ec2]  # Ensure EC2 is created before running the playbook
# }

# Output the public IPs
output "jenkins_ec2_public_ip" {
  value = module.jenkins_ec2.ec2_public_ip
}

output "sonarqube_ec2_public_ip" {
  value = module.sonarqube_ec2.ec2_public_ip
}
