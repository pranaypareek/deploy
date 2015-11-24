# .10 SubNet security group
resource "aws_security_group" "demoPrivSG0-1" {
  name = "demoPrivSG0-1"
  description = "Private 0.1 Subnet security group"
  vpc_id = "${aws_vpc.demoVPC.id}"

  ingress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.public0-0CIDR}"]
  }

  # allow only outbound http traffic
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

  tags {
    Name = "demoPrivSG0-1"
  }
}

# Container instances for ECS
resource "aws_instance" "demoECSIns" {
  count = 2

  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.availability_zone}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.demoPrivSN0-1.id}"

  security_groups = [
    "${aws_security_group.demoPrivSG0-1.id}"]

  root_block_device {
    volume_type = "io1"
    volume_size = 32
    iops = 800
    delete_on_termination = true
  }

  user_data = "#!/bin/bash \n echo ECS_CLUSTER=${aws_ecs_cluster.demoCL.name} >> /etc/ecs/ecs.config"
  iam_instance_profile = "${aws_iam_instance_profile.demoECSInstProf.name}"

  tags = {
    Name = "demoECSIns${count.index}"
  }
}
