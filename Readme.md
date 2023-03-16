# AWS Modules

Welcome to `aws-modules`, a collection of Terraform and Terragrunt modules designed 
to simplify and accelerate your AWS infrastructure deployment. 
Our modules provide best-practice configurations for common AWS resources, 
ensuring a secure and efficient setup for your applications.

## Modules Overview

Here's a quick rundown of the modules included in this repository:

* networking: Create a VPC with configurable options such as no private subnets or custom security rules
* s3: Create an encrypted, private S3 bucket.
* secrets_manager: Manage and retrieve secrets using AWS Secrets Manager.
* route53: Set up and manage DNS records with AWS Route 53.
* ecs: Deploy and manage containerized applications using AWS Elastic Container Service (ECS) in a fargate cluster
* cloudfront/s3_origin: Configure an Amazon CloudFront distribution with an S3 bucket as its origin.
* acm: Manage AWS Certificate Manager (ACM) certificates with Route 53 validation support.
* alb: Set up an Application Load Balancer (ALB) that can be configured with ECS.

## Example: ServerlessForms Full Stack Setup

To demonstrate how to use these modules, we've provided a full-stack example for 
setting up ServerlessForms on AWS using ECS in the examples directory. This 
example showcases how to configure a complete infrastructure using the modules 
described above.

We hope you find these modules helpful in streamlining your AWS 
infrastructure deployment. Happy coding! 🚀
