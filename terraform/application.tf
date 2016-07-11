resource "aws_security_group" "app_security_group" {
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["86.31.223.94/32"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = ["${aws_security_group.elb_security_group.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.system_name_prefix} Application Security Group"
        System = "${var.system_tag}"
    }
}

resource "aws_security_group" "elb_security_group" {
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.system_name_prefix} ELB Security Group"
        System = "${var.system_tag}"
    }
}

resource "aws_elb" "load_balancer" {
    name = "${format("ec2-elb-%.8s", sha1("${var.system_name_prefix} Load Balancer"))}"
    security_groups = ["${aws_security_group.elb_security_group.id}"]
    subnets = ["${split(",", var.public_subnet_ids)}"]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 443
        lb_protocol = "https"
    }

    tags {
        Name = "${var.system_name_prefix} Elastic Load Balancer"
        System = "${var.system_tag}"
    }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
    max_size = 1
    min_size = 1
    launch_configuration = "${aws_launch_configuration.app_launch_configuration.name}"
    vpc_zone_identifier = ["${split(",", var.public_subnet_ids)}"]
    load_balancers = ["${aws_elb.load_balancer.name}"]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "${var.system_name_prefix} AutoScaling Group"
        propagate_at_launch = true
    }

    tag {
        key = "System"
        value = "${var.system_tag}"
        propagate_at_launch = true
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_launch_configuration" "app_launch_configuration" {
    image_id = "ami-f9dd458a" # HVM (SSD) EBS-Backed 64-bit
    instance_type = "t2.nano"
    security_groups = ["${aws_security_group.app_security_group.id}"]
    associate_public_ip_address = true
    key_name = "${var.ssh_key_name}"
    user_data = "${file("${path.module}/user-data.sh")}"

    root_block_device {
        volume_type = "gp2"
        volume_size = "10"
    }

    lifecycle {
        create_before_destroy = true
    }
}
