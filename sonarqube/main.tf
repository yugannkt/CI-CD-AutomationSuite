terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "tcp://${var.ec2_public_ip}:2375/"
}

resource "docker_volume" "sonarqube_volumes" {
  for_each = var.sonarqube_volumes
  name     = each.key
}

resource "docker_container" "sonarqube" {
  image = var.sonarqube_image
  name  = var.sonarqube_container_name

  ports {
    internal = 9000
    external = var.sonarqube_ports["9000"]
  }

  dynamic "volumes" {
    for_each = var.sonarqube_volumes
    content {
      volume_name    = volumes.key
      container_path = volumes.value
    }
  }

  restart = "always"
}
