# Terraform code for deploying the required infrastructure for OTTO GCP Phase 1

Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform.

https://www.terraform.io/

This Terraform configuration sets up the infrastructure for Phase 1 of OTTO GCP Migration.

https://github.com/mihai-jelea/otto-terraform-config

> **Important note:** The code only covers part of the infrastructure (the network configuration, subnets, firewall rules, IAM, APIs, MIGs, HTTPS LB, production Cloud SQL).

## Environments

2 identical environments have been configured `dev` and `prod` 
For this, the `environments` folder contains sub-folders for each environment

For each environment, specific configs are stored in `terraform.tfvars` and `backend.tf` files. 
If the infrastructure would differ between environments, we would have different `main.tf` files in each environment folder.

## Phase 1 Architecture Diagram

![alt text](/docs/architecture.png)

## Quick start

You must have a [Google Cloud Platform (GCP)](http://cloud.google.com/) account and a project with a billing account set.

Create a service account with the required permissions and download service account key (in json format) in the root directory for authentication.

Go to the desired environment folder and configure the `terraform.tfvars` file to set the environment variables, like project id, billing account, json credentials file, region and zone. 

Run the Terraform commands from the root folder. 

To initialize your Terraform configuration run the following command (make sure to select the correct folder for the desired environment):

`terraform -chdir=./environments/dev init`

Then plan and apply the infrastructure using the same parameter as above. 

`terraform -chdir=./environments/dev plan`

`terraform -chdir=./environments/dev apply`

## Modules

The list of used modules:

* [network](modules/network/main.tf) - Here you will find the configuration for the network
* [compute_instances](modules/compute/main.tf) - Here you will find the configuration for all the required GCE instances
* [databases](modules/database/main.tf) - Here you will find the configuration for all the required database instances
* [load_balancers](modules/network/main.tf) - Here you will find the configuration for all the required load balancers
* [firewall](modules/network/firewall.tf) - Here you will find the configuration for the firewall
* [storage](modules/storage/main.tf) - Here you will find the configuration for the required storage buckets
* [api](modules/api/main.tf) - Here you will find the enabled APIs


## License

Author: Mihai Jelea

Email: mihai.jelea@gmail.com