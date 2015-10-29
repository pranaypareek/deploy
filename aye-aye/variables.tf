variable "aws_access_key_id" {
  description = "AWS access key"
}

variable "aws_secret_access_key" {
  description = "AWS secert access key"
}

variable "region"     { 
  description = "AWS region"
  default     = "us-east-1" 
}

variable "key_name"     {
  description = "Pem key associated with instances"
}

variable "availability_zone"     { 
  description = "AWS availability zone"
  default     = "us-west-2c" 
}

variable "vpc_name" {
  description = "Shippable aye aye vpc name"
  default     = "shippable_aye_aye_vpc"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.128.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  default     = "10.128.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  default     = "10.128.1.0/24"
}

/* Ubuntu 14.04 amis by region */
variable "amis" {
  description = "Base AMI to launch the instances with"
  default = {
    us-east-1 = "ami-c16422a4"
    us-west-1 = "ami-c9ae688d"
    us-west-2 = "ami-478b9177"
    eu-west-1 = "ami-6b12271c"
    ap-northest-1 = "ami-6e920b6e"
    ap-southest-2 = "ami-fb0d45c1"
  }
}
