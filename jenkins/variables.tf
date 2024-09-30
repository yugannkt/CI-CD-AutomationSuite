variable "jenkins_ec2_public_ip" {
  description = "Public IP of the Jenkins EC2 instance."
  type        = string
}

variable "jenkins_image" {
  description = "The Docker image for Jenkins."
  type        = string
  default     = "jenkins/jenkins:lts"
}

variable "jenkins_container_name" {
  description = "The name of the Jenkins container."
  type        = string
  default     = "jenkins"
}

variable "jenkins_ports" {
  description = "Ports to expose for the Jenkins container."
  type        = map(number)
  default     = {
    "8080"  = 8080,
    "50000" = 50000
  }
  
}

variable "apache_ports" {
  description = "Map of external ports for the Apache container."
  type        = map(number)  # Change to 'map(string)' if you prefer using strings for port numbers
  default     = {
    "80"  = 8081  # Example mapping: internal port 80 to external port 8081
  }
}

