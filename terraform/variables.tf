variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-northeast-3"
}

variable "project_name" {
  description = "Prefix used to tag/name all resources"
  type        = string
  default     = "k8s-lab"
}

variable "instance_type" {
  description = "EC2 instance type for cluster nodes"
  type        = string
  default     = "t3.small"
}

variable "public_key_path" {
  description = "Path to the SSH public key to install on instances"
  type        = string
  default     = "~/.ssh/k8s-lab/k8s-lab-key.pub"
}

variable "my_ip" {
  description = "Your public IP in CIDR form, e.g. 1.2.3.4/32 — used to lock down SSH access. Run `curl -s https://checkip.amazonaws.com` to find yours."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "alert_email" {
  description = "Email address to receive the billing alarm notification"
  type        = string
}

variable "billing_threshold_usd" {
  description = "Trigger the billing alarm if estimated charges exceed this amount (USD)"
  type        = number
  default     = 25
}
