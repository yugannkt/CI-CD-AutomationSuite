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
