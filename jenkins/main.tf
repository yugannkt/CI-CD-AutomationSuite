terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "tcp://${var.jenkins_ec2_public_ip}:2375/"
}

resource "null_resource" "install_apache" {
  # This will run once you apply this configuration
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "sudo ufw allow 80/tcp"  # Allow HTTP traffic
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # or "ec2-user", depending on your AMI
      private_key = file("poc4.pem")  # Path to your PEM key
      host        = var.jenkins_ec2_public_ip  # The public IP of your EC2 instance
    }
  }
}

resource "docker_image" "jenkins" {
  name         = var.jenkins_image
  keep_locally = false
}

resource "docker_container" "jenkins" {
  image = docker_image.jenkins.name
  name  = var.jenkins_container_name

  ports {
    internal = 8080
    external = var.jenkins_ports["8080"]
  }

  ports {
    internal = 50000
    external = var.jenkins_ports["50000"]
  }
 
 
}
