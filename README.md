# Documented and diagram of the ideal approach to an IaC setup with respect to a proven, scalable, and highly-reliant build/test/deploy/release process

## Requirements

Need to install terraform, terragrunt.
With the correct Keys can run in any AWS account

## Step to deploy

Go to deployments --> dev/prod --> region --> applications --> aws-service-to-deploy 

run :
        terragrunt init
        terragrunt plan
        terragrunt apply

## Goals

the inputs

You need to define how many routes want to create
Use different python script for the lambda but for this test I use the same only modify the key number.
I create a datalake where store the s3 values.

## Implementation

I create the structure using terragrunt for the escalation of the infrastructure and resources 

## Inputs

No inputs.

## Outputs

No outputs.
