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

  restart = "always"
}
