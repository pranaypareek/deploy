#========================== VPC  =============================

# Define a vpc
resource "aws_vpc" "demoVPC" {
  cidr_block = "${var.networkCIDR}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "demoIG" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  tags {
    Name = "demoIG"
  }
}

#========================== 0.0 Subnet =============================

# Public subnet
resource "aws_subnet" "demoPubSN0-0" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  cidr_block = "${var.public0-0CIDR}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "demoPubSN0-0-0"
  }
}

# Routing table for public subnet
resource "aws_route_table" "demoPubSN0-0RT" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demoIG.id}"
  }
  tags {
    Name = "demoPubSN0-0RT"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "demoPubSN0-0RTAssn" {
  subnet_id = "${aws_subnet.demoPubSN0-0.id}"
  route_table_id = "${aws_route_table.demoPubSN0-0RT.id}"
}

#========================== 0.1 subnet ======================

# Private 0.1 subnet
resource "aws_subnet" "demoPrivSN0-1" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  cidr_block = "${var.private0-1CIDR}"
  availability_zone = "${var.availability_zone}"
  tags {
    Name = "demoPrivSN0-1"
  }
}

# Routing table for private subnet
resource "aws_route_table" "demoPrivSN0-1RT" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.demoNAT.id}"
  }
  tags {
    Name = "demoPrivSN0-1RT"
  }
}

# Associate the routing table to private subnet
resource "aws_route_table_association" "demoPrivSN0-1RTAssn" {
  subnet_id = "${aws_subnet.demoPrivSN0-1.id}"
  route_table_id = "${aws_route_table.demoPrivSN0-1RT.id}"
}

#========================== NAT =============================

# NAT SG
resource "aws_security_group" "natSg" {
  name = "NATSG"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "${var.private0-1CIDR}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "${var.private0-1CIDR}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "${var.networkCIDR}"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.demoVPC.id}"

  tags {
    Name = "NATSG"
  }
}

# NAT Server
resource "aws_instance" "demoNAT" {
  # this is a special ami preconfigured to do NAT
  ami = "ami-c02b04a8"
  availability_zone = "${var.availability_zone}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"

  subnet_id = "${aws_subnet.demoPubSN0-0.id}"
  security_groups = [
    "${aws_security_group.natSg.id}"]

  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "demoNAT"
  }
}

# Associate EIP, without this private SN wont work
resource "aws_eip" "nat" {
  instance = "${aws_instance.demoNAT.id}"
  vpc = true
}

# make this routing table the main one
resource "aws_main_route_table_association" "demoPrivSN0-1RTMain" {
  vpc_id = "${aws_vpc.demoVPC.id}"
  route_table_id = "${aws_route_table.demoPrivSN0-1RT.id}"
}
