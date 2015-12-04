# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
}

variable "region" {
  description = "AWS region"
  default = "us-west-2"
}

variable "availability_zone" {
  description = "availability zone used for trriplejay test"
  default = "us-west-2a"
}

# Special AMI for ECS container Service
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
      us-west-2 = "ami-d74357b6"
  }
}

# this is a PEM key for key pairs
variable "key_name" {
  description = "Key Pair Name used to login to the box"
}

# all variables related to VPC
variable "vpc_name" {
  description = "VPC for the cluster system"
  default = "trriplejayVPC"
}

variable "networkCIDR" {
  description = "Uber IP addressing for the Network"
  default = "10.0.0.0/16"
}

variable "public0-0CIDR" {
  description = "Public 0.0 CIDR for externally accesible subnet"
  default = "10.0.0.0/24"
}

variable "private0-1CIDR" {
  description = "Private 0.1 block for container instances"
  default = "10.0.1.0/24"
}
