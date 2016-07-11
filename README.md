# WordPress on AWS with Terraform and Ansible

```
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=mainthread-technology-logs" \
    -backend-config="key=terraform/terraform-ansible-example/terraform.tfstate" \
    -backend-config="region=eu-west-1"
```
