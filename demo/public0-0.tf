# Web Security group
resource "aws_security_group" "trriplejayWebSG" {
  name = "trriplejayWebSG"
  description = "Web traffic security group"
  vpc_id = "${aws_vpc.trriplejayVPC.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
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
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "${var.private0-1CIDR}"]
  }
  tags {
    Name = "trriplejayWebSG"
  }
}

# ========================Load Balancers=======================

# WWW Load balancer
resource "aws_elb" "trriplejayWWWLb" {

  name = "trriplejayWWWLb"
  subnets = [
    "${aws_subnet.trriplejayPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.trriplejayWebSG.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }

  instances = [
    "${aws_instance.trriplejayECSIns.*.id}"]
}

# API Load balancer
resource "aws_elb" "trriplejayAPILb" {

  name = "trriplejayAPILb"
  subnets = [
    "${aws_subnet.trriplejayPubSN0-0.id}"]
  security_groups = [
    "${aws_security_group.trriplejayWebSG.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 5
  }

  instances = [
    "${aws_instance.trriplejayECSIns.*.id}"]
}
