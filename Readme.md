# AWS Modules

Welcome to `aws-modules`, a collection of Terraform and Terragrunt modules designed to simplify and accelerate your AWS infrastructure deployment. Our modules provide best-practice configurations for common AWS resources, ensuring a secure and efficient setup for your applications.

## Modules Overview

Here's a quick rundown of the modules included in this repository:

* Networking
  * *No Private Subnets*: Create a VPC with only public subnets with provided availability zones and cidr ranges.
  * *One Nat Gateway*: Create a VPC having both public & private subnets considering provided availability zones and cidr ranges with only one nat gateway for all private subnets.
  * *Security Group*: Create a security group with ingress / egress rules as defined.
* S3
  * *Encrypted Private Bucket*: Create an encrypted, private S3 bucket optionally with managed kms key.
* Secrets Manager
  * *Simple*: Create an AWS secret manager key with initial secrets as provided taking away complexity of setting it up on your own.
* *Route53*: Set up and manage DNS records with AWS Route 53.
* Ecs
  * *Fargate Cluster*: Deploy and manage containerized applications using AWS Elastic Container Service (ECS) in a fargate cluster
  * *Service*: Create both ecs task definition and service which supports linking to AWS Load Balancers.
* Cloudfront
  * *S3 Origin*: Configure an Amazon CloudFront distribution with an S3 bucket as its origin. Supports extra origin configurations as well.
* Acm
  * *Validate with Route53*: Manage AWS Certificate Manager (ACM) certificates with Route 53 validation support.
* Load Balancer
  * *Alb*: Set up an Application Load Balancer (ALB) with listener configurations as needed.
* RDS
  * *Postgres*: Set up a Postgres instance with multi az support, cloudwatch logs, performance insights etc. in your selected subnet(s).
* Key Pair: Create a key pair to ssh into aws instances.
* Http Request: Get a file from internet to use in your terraform modules / resources.
* EKS
  * *Cluster*: Create an eks cluster with managed node groups and vpc cni addon configuration predefined for networking and configure kms key owners / admins etc. for managing.
  * *Cluster Autoscaler IRSA Role*: Create a cluster autoscaler addon irsa role with predefined iam permissions as required.
  * *External DNS IRSA Role*: Create an external dns addon irsa role with predefined iam permissions as required.
  * *Helm Release*: Deploy an Helm chart into your EKS cluster.
  * *Independent Yaml Manifests*: Deploy all kubernetes manifests in a single yaml file which doesn't depend on each other in parallel into your EKS cluster using kubectl provider.
  * *Manifests Local Exec*: Deploy all your manifests into your eks cluster which are in a single yaml file and requires sequential execution support. For example, [Tekton pipelines](https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml) setup, requires all manifests are applied sequentially as defined.

## Example Implementations

To demonstrate how to use these modules, we've provided two examples, one to setup ServerlessForms application and another for configuring an Internal Developer Platform(WIP) for your organization.

### ServerlessForms Full Stack Setup

[Here](./examples/serverlessforms/) you can find, ServerlessForms product's full-stack setup on AWS using ECS(api) and Cloudfront(website) using [Terragrunt](https://terragrunt.gruntwork.io/docs/#getting-started) modules.

### Internal Developer Platform(WIP)

[Here](./examples/internal_developer_platform/) you can see, configuring infrastructure for your organization's Internal Developer Platform product on AWS using EKS using [Terragrunt](https://terragrunt.gruntwork.io/docs/#getting-started) modules. Please note that this is a work in progress product and tends to change in future.

Both of these examples, showcases how to configure a complete infrastructure using the modules described above. We hope you find these modules helpful in streamlining your AWS infrastructure deployment. Happy coding! 🚀
