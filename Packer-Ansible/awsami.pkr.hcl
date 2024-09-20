packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}
source "amazon-ebs" "ubuntu" {
  ami_name      = "custom-ami-new"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami = "ami-0e86e20dae9224db8"
  ssh_username = "ubuntu"
}
build {
  name    = "docker-ami"
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "ansible" {
    playbook_file = "install_docker.yml"
  }
}
