/* ui Load balancer */
resource "aws_elb" "shippable_aye_aye_ui_lb" {
  name = "shippable-aye-aye-ui-lb"
  subnets = ["${aws_subnet.shippable_aye_aye_pub_sn.id}"]
  security_groups = ["${aws_security_group.shippable_aye_aye_sg.id}", "${aws_security_group.shippable_aye_aye_web_sg.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = ["${aws_instance.app.*.id}"]
}

/* Load balancer */
resource "aws_elb" "shippable_aye_aye_api_lb" {
  name = "shippable-aye-aye-api-lb"
  subnets = ["${aws_subnet.shippable_aye_aye_pub_sn.id}"]
  security_groups = ["${aws_security_group.shippable_aye_aye_sg.id}", "${aws_security_group.shippable_aye_aye_web_sg.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = ["${aws_instance.app.*.id}"]
}
