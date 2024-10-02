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

resource "local_file" "inventory_ini" {
  content = <<EOF
[Jenkins]
${module.jenkins_ec2.ec2_public_ip} ansible_user=ubuntu public_ip=${module.jenkins_ec2.ec2_public_ip} ansible_ssh_private_key_file=/home/yugan/POC4/poc4.pem

[Sonarqube]
${module.sonarqube_ec2.ec2_public_ip} ansible_user=ubuntu public_ip=${module.sonarqube_ec2.ec2_public_ip} ansible_ssh_private_key_file=/home/yugan/POC4/poc4.pem
EOF

  filename = "${path.module}/ansible_script/inventory.ini"
}




# Run Ansible Playbook after generating the inventory file
resource "null_resource" "run_sonarqube_playbooks" {
  provisioner "local-exec" {
    command = <<-EOT
      bash -c "ansible-playbook -i ${path.module}/ansible_script/inventory.ini ${path.module}/ansible_script/sonarqube_setup.yml -vvv -e 'ansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"'"
    EOT
  }
  depends_on = [
    local_file.inventory_ini,
    module.SonarQube  # Ensure SonarQube instance is created before running the playbook
  ]
}
resource "null_resource" "run_jenkins_playbooks" {
  provisioner "local-exec" {
    command = <<-EOT
      bash -c "ansible-playbook -i ${path.module}/ansible_script/inventory.ini ${path.module}/ansible_script/jenkins_setup.yml -vvv -e 'ansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"'"
    EOT
  }
  depends_on = [
    local_file.inventory_ini,
    module.Jenkins,  # Ensure Jenkins instance is created before running the playbook
    null_resource.run_sonarqube_playbooks  # Ensure SonarQube playbook runs before Jenkins playbook
  ]
}

# Output the public IPs
output "jenkins_ec2_public_ip" {
  value = module.jenkins_ec2.ec2_public_ip
}

output "sonarqube_ec2_public_ip" {
  value = module.sonarqube_ec2.ec2_public_ip
}
