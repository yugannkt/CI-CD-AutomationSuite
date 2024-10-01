variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
  default     = "ami-0605eea6c0becbdb3"
}

variable "jenkins_instance_type" {
  description = "The instance type for Jenkins."
  type        = string
  default     = "t2.medium"
}

variable "sonarqube_instance_type" {
  description = "The instance type for SonarQube."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The key pair name for SSH access."
  type        = string
  default = "poc4"
}

variable "jenkins_app_port" {
  description = "The port for Jenkins."
  type        = number
  default     = 8080
}

variable "sonarqube_app_port" {
  description = "The port for SonarQube."
  type        = number
  default     = 9000
}
