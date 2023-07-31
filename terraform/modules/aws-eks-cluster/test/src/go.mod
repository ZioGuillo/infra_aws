module github.com/cloudposse/terraform-aws-eks-cluster

go 1.16

require (
	github.com/aws/aws-sdk-go v1.43.28
	github.com/gruntwork-io/terratest v0.36.5
	github.com/stretchr/testify v1.7.0
	k8s.io/api v0.22.1
	k8s.io/client-go v0.22.1
	sigs.k8s.io/aws-iam-authenticator v0.5.9
)
