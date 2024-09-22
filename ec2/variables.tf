variable "ami_id" {
  description = "The AMI ID for the EC2 instances."
  type        = string
  default     = "ami-0605eea6c0becbdb3"
}

variable "instance_type" {
  description = "The instance type for the EC2 instances."
  type        = string
}

variable "key_name" {
  description = "The key pair name for SSH access."
  type        = string
}

variable "instance_name" {
  description = "The name of the EC2 instance."
  type        = string
}

variable "app_port" {
  description = "The port for the application."
  type        = number
}
