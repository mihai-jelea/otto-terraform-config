# The Network Module

This module deals with all networking configurations necessary for OTTO Phase 1 Infrastructure

## Configuration

The following resources are created:

* VPC
* 2 Subnets: external and internal
* Cloud Router and NAT to allow web app VMs to access the Mailgun API via HTTPS (to send transactional emails)
* Firewall rules