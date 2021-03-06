################################################
## This file contains security groups required #
## for ECS to ingress and egress with outside  #
################################################

resource "aws_security_group" "alb-sg" {
  name        = "alb-ingress"
  description = "ALB Ingress from outside subnet"
  vpc_id      = "${aws_vpc.demo-vpc.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["${var.internet_cidr}"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["${var.internet_cidr}"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["${var.internet_cidr}"]
  }
}
resource "aws_security_group" "website-sg" {
  name        = "ingress-to-website"
  description = "Ingress from ALB to website"
  vpc_id      = "${aws_vpc.demo-vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.website_port}"
    to_port         = "${var.website_port}"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.internet_cidr}"]
  }
}
resource "aws_security_group" "jumpdude-sg" {
  name        = "ingress-to-game"
  description = "Ingress from ALB to game"
  vpc_id      = "${aws_vpc.demo-vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.game_port}"
    to_port         = "${var.game_port}"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.internet_cidr}"]
  }
}
