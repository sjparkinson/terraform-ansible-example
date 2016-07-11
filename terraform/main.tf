# Main definition file, including provider configuration
# and variable definitions.

# Use the standard AWS CLI configuration file or environment variables.
provider "aws" {
    region = "${var.aws_region}"
}

variable "aws_region" {
    type = "string"
}

variable "vpc_id" {
    type = "string"
}

variable "ssh_key_name" {
    type = "string"
}

variable "public_subnet_ids" {
    type = "string"
}

variable "private_subnet_ids" {
    type = "string"
}

variable "system_tag" {
    type = "string"
}

variable "system_name_prefix" {
    type = "string"
}

variable "db_username" {
    type = "string"
}

variable "db_password" {
    type = "string"
}
