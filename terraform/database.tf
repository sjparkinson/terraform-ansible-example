# Definition of the database instance.

output "rds_endpoint" {
    value = "${aws_db_instance.default.endpoint}"
}

resource "aws_security_group" "db_security_group" {
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.app_security_group.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.system_name_prefix} Database Security Group"
        System = "${var.system_tag}"
    }
}

resource "aws_db_subnet_group" "default" {
    name = "${format("rds-sng-%.8s", sha1("${var.system_name_prefix} DB Subnet Group"))}"
    description = "RDS subnet group for the ${var.system_name_prefix} system."
    subnet_ids = ["${split(",", var.private_subnet_ids)}"]

    tags {
        Name = "${var.system_name_prefix} RDS Subnet Group"
        System = "${var.system_tag}"
    }
}

resource "aws_db_parameter_group" "default" {
    name = "${format("rds-pg-%.8s", sha1("${var.system_name_prefix} DB Subnet Group"))}"
    family = "mysql5.6"
    description = "RDS parameter group for the ${var.system_name_prefix} system."

    tags {
        Name = "${var.system_name_prefix} RDS Parameter Group"
        System = "${var.system_tag}"
    }
}

resource "aws_db_instance" "default" {
    engine = "mysql"
    engine_version = "5.6.29"

    instance_class = "db.t2.micro"

    storage_type = "gp2"
    allocated_storage = 10

    multi_az = true
    backup_retention_period = "1"

    name = "wordpress"
    username = "${var.db_username}"
    password = "${var.db_password}"

    db_subnet_group_name = "${aws_db_subnet_group.default.name}"
    parameter_group_name = "${aws_db_parameter_group.default.name}"
    vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]

    tags {
        Name = "${var.system_name_prefix} RDS Instance"
        System = "${var.system_tag}"
    }
}
