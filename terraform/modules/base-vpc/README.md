base-vpc
==========

# Overview

Terraform module for creating a new VPC network

The module creates a /16 VPC network and automatically subnets the range based on the number of availability zones in the user specified region

A Virtual Private Cloud (VPC) is a virtual network in AWS that allows you to launch AWS resources in a logically isolated area. You can create multiple subnets within a VPC, each of which can be associated with a different availability zone (AZ).

Here is a breakdown of the different types of subnets and their purpose:

Public subnets: These subnets are connected to the internet via an Internet Gateway (IGW). Resources in public subnets can communicate with the internet, and they can also be accessed from the internet via their public IP addresses.

Private subnets: These subnets are not directly connected to the internet. Resources in private subnets can communicate with the internet via a NAT Gateway (Network Address Translation Gateway) or a NAT instance. Private subnets are typically used for resources that don't need direct internet access, such as databases or application servers.

NAT subnets: These subnets are used to host NAT Gateways or NAT instances. NAT Gateways or NAT instances allow resources in private subnets to communicate with the internet, but they do not allow incoming connections from the internet.

Private Elastic Load Balancer (ELB) subnets: These subnets are used to host private Elastic Load Balancers (ELBs). Private ELBs

The purpose of a "Fort Knox" subnet, which is typically a private subnet with no inbound or outbound connectivity to the internet, is to provide an additional layer of security for sensitive resources. By isolating these resources from the internet, you can reduce the risk of external attacks and ensure that they are only accessible through authorized channels.

For example, you might use a Fort Knox subnet to host a database that stores sensitive data, such as financial records or personal information. By isolating the database from the internet, you can prevent unauthorized access and reduce the risk of data breaches.

To create a Fort Knox subnet in AWS, you can create a private subnet and then configure the appropriate security groups and network access control lists (ACLs) to deny inbound and outbound traffic to and from the internet. You can also use a NAT Gateway or NAT instance to allow resources in the Fort Knox subnet to communicate with the internet, but only for specific, authorized purposes.

Keep in mind that a Fort Knox subnet is not a replacement for other security measures, such as proper authentication and authorization controls, encryption, and regular security assessments. It is just one aspect of a comprehensive security strategy.

A route table in AWS is a collection of routes that specify how traffic is routed within a VPC. Each subnet in a VPC can be associated with a route table, which determines where traffic is directed when it is destined for that subnet.

For example, you can use a route table to specify that traffic destined for a particular subnet should be routed to a specific Internet Gateway (IGW) or NAT Gateway (Network Address Translation Gateway). This allows you to control how traffic is routed within your VPC and to specify which resources have access to the internet.

You can create multiple route tables in a VPC and associate them with different subnets to specify different routing rules for each subnet. For example, you might create a separate route table for public subnets and a separate route table for private subnets, with different routing rules for each.

You can also use route tables to implement network security measures, such as allowing or denying traffic based on the source or destination IP address, protocol, or port.

In summary, route tables are a key component of a VPC and are used to control how traffic is routed within the VPC and to specify which resources have access to the internet.

An Elastic IP (EIP) is a static IP address that you can assign to an AWS resource, such as an EC2 instance or a NAT Gateway. EIPs are used to allow resources to be reachable over the internet, even if their underlying IP address changes.

A NAT Gateway (Network Address Translation Gateway) is an AWS service that allows resources in private subnets to communicate with the internet, while preventing incoming connections from the internet. NAT Gateways use EIPs to allow outbound traffic to flow to the internet.

An Internet Gateway (IGW) is an AWS service that allows resources in public subnets to communicate with the internet. IGWs are used to allow incoming and outgoing traffic between the internet and the VPC.

In a VPC with public and private subnets, the IGW is typically associated with the public subnets and the NAT Gateway is typically associated with the private subnets. This allows resources in the public subnets to communicate directly with the internet, while resources in the private subnets can only communicate with the internet via the NAT Gateway.

The EIPs are used by the NAT Gateway to allow outbound traffic to flow to the internet, while incoming traffic is not allowed. This allows you to control which resources have direct internet access and which resources must go through the NAT Gateway to access the internet.

In summary, the EIP, NAT Gateway, and IGW are all components of a VPC and are used to control how resources within the VPC can communicate with the internet. The EIP is used by the NAT Gateway to allow outbound traffic to flow to the internet, while the NAT Gateway and IGW are used to control incoming traffic.

Security groups are a key component of AWS security, and they are used to control inbound and outbound traffic to and from resources in a VPC.

The names of the default security groups you listed, such as "allow_all_intra_vpc_ingress_vpc" and "allow_all_egress", suggest that they may be configured to allow all traffic in certain directions.

Here is a breakdown of the purpose of each of these default security groups:

allow_all_intra_vpc_ingress_vpc: This security group is likely configured to allow all inbound traffic from within the VPC. This could include traffic from other resources within the same VPC, such as EC2 instances, RDS databases, or Lambda functions.

allow_all_intra_vpc: This security group is likely configured to allow all traffic between resources within the same VPC. This could include traffic from resources in different subnets or availability zones within the VPC.

allow_all_intra_vpc_egress: This security group is likely configured to allow all outbound traffic to destinations within the VPC. This could include traffic to other resources within the same VPC, such as EC2 instances, RDS databases, or Lambda functions.

allow_all_ingress: This security group is likely configured to allow all inbound traffic from any source. This could include traffic from the internet or from other VPCs.

allow_all_egress: This security group is likely configured to allow all outbound traffic to any destination. This could include traffic to the internet or to other VPCs.

allow_all: This security group is likely configured to allow all traffic in both directions, both inbound and outbound.

It is generally not recommended to use security groups that allow all traffic, as they do not provide any security and can leave your resources vulnerable to attacks. Instead, it is best to create custom security groups that are tailored to your specific security needs and that only allow the traffic that is necessary for your resources to function properly.

In summary, default security groups are used to control traffic to and from resources in a VPC, and they can be configured to allow different types of traffic based on the source, destination, and direction. It is important to carefully consider your security needs and configure your security groups appropriately to ensure that your resources are protected.


## Resources Deployed

- VPC Network
- Subnets (one for each regions availability zones) 
    - Public
    - Private
    - NAT
    - Private ELB (for load balancers)
    - Fort Knox (no inbound or outbound connectivity to the internet)
- Route tables for each subnet
- AWS Internet Gateway (gateway for public subnets)
- AWS NAT Gateway (gateway for private subnets)
- Elastic IP (for NAT Gateway)
- Default Security Groups
    - allow_all_intra_vpc_ingress_vpc
    - allow_all_intra_vpc
    - allow_all_intra_vpc_egress
    - allow_all_ingress
    - allow_all_egress
    - allow_all

# Testing
When deploying you should expect to see something similar to the following:
```
❯ terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

