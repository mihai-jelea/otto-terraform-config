# Terraform code for deploying the required infrastructure for OTTO GCP Phase 1

Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.

https://www.terraform.io/

This Terraform configuration sets up the infrastructure for Phase 1 of OTTO GCP Migration.

https://github.com/mihai-jelea/otto-terraform-config

**Important node:** The code only covers part of the infrastructure (the network configuration, subnets, firewall rules, IAM, APIs, MIGs, HTTPS LB, production Cloud SQ).

## Phase 1 Architecture Diagram

![alt text](/docs/architecture.png)

## Quick start

You must have a [Google Cloud Platform (GCP)](http://cloud.google.com/) account.

Make sure to add you service account key (in json format) in the root directory for authentication.

Go to the `terraform.tfvars` file and configure your environment variables, like project id, billing account, json credentials file, region and zone. 

Initialize your Terraform workspace, which will download the provider and initialize it with the credentials provided.

` terraform init `

Then, run `terraform plan` and check the configuration carefully. If all seems in order, run `terraform apply` to deploy the infrastructure to Google Cloud.

## Modules

The list of used modules:

* [network](modules/network/main.tf) - Here you will find the configuration for the network
* [compute_instances](modules/compute/main.tf) - Here you will find the configuration for all the required GCE instances
* [databases](modules/database/main.tf) - Here you will find the configuration for all the required database instances
* [load_balancers](modules/network/main.tf) - Here you will find the configuration for all the required load balancers
* [firewall](modules/network/firewall.tf) - Here you will find the configuration for the firewall
* [storage](modules/storage/main.tf) - Here you will find the configuration for the required storage buckets
* [api](modules/api/main.tf) - Here you will find the enabled APIs


## Environments

Normally, we would use and `env` folder containing environment specific variable configurations so that the infrastructure can be deployed to multiple environments.
For each environment we would have specific configs in `terraform.tfvars` and `backend.tf` files. If the infrastructure differs, we would have different `main.tf` files in each environment folder.

For the sake of the exercise I've only created the folders (they are empty)

## License

Author: Mihai Jelea

Email: mihai.jelea@gmail.com