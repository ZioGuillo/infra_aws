# Biome

## Overview
This Terraform deployment deploys a VPC network and default EKS cluster into an AWS account.

## Prerequisites
Please refer to the details in HiveWatch's [Infrastructure Development page](https://hivewatch.atlassian.net/wiki/spaces/EN/pages/819232793).

## Instructions
If you are unfamiliar with Terraform or Terragrunt please refer to the following:
- [Terraform](https://hivewatch.atlassian.net/wiki/spaces/EN/pages/819331088)
- [Terragrunt](https://hivewatch.atlassian.net/wiki/spaces/EN/pages/819363851)

### 1. Navigate to the appropriate deployment

There are multiple deployments located in `./terraform/deployments`, so you'll want to change your directory to the nested directory corresponding to the deployment you're applying.

#### Example

```
❯ cd terraform/deployments/dev/us-west-2/hivewatch/biome
❯ terragrunt plan
module.vpc.aws_eip.nat: Refreshing state... [id=eipalloc-01f44bcef7fa60f9f]
...
...
No changes. Your infrastructure matches the configuration.
```

### 2. Edit `aws-auth` ConfigMap to add roles to cluster

```sh
kubectl edit configmap aws-auth -n kube-system
```

This step is not currently automated with Terraform, because the ConfigMap
is modified outside of Terraform when
the cluster is joined by new [Fargate](https://aws.amazon.com/fargate/)
nodes.

Sample addition for mapping github actions role to k8s group:

```
    - groups:
      - system:masters
      rolearn: arn:aws:iam:::role/-dev-github-actions
      username: system:node:{{SessionName}}
```

#### Warning

Take care when editing the ConfigMap, because some of these roles are
necessary for us to access the cluster, so if you delete them, we will lose
access to the cluster.

## Testing Kube API Access
1. Confirm the cluster has been deployed: `aws --profile hivewatch-dev eks list-clusters`
2. Update your local kubeconfig `aws --profile hivewatch-dev eks update-kubeconfig --name dev-default-cluster`
3. Try to pull pods on the cluster: `kubectl get pods -A`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.68.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.68.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | ../aws-eks-cluster | n/a |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../base-vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.biome](https://registry.terraform.io/providers/hashicorp/aws/3.68.0/docs/resources/db_subnet_group) | resource |
| [aws_eks_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/3.68.0/docs/data-sources/eks_cluster) | data source |
| [aws_iam_roles.admin](https://registry.terraform.io/providers/hashicorp/aws/3.68.0/docs/data-sources/iam_roles) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_cidr_base"></a> [cidr\_base](#input\_cidr\_base) | n/a | `string` | n/a | yes |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | `number` | `0` | no |
| <a name="input_eks_name"></a> [eks\_name](#input\_eks\_name) | n/a | `string` | `"default"` | no |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | n/a | `bool` | `true` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | <pre>[<br>  "api",<br>  "audit",<br>  "authenticator",<br>  "controllerManager",<br>  "scheduler"<br>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `""` | no |
| <a name="input_map_additional_iam_roles"></a> [map\_additional\_iam\_roles](#input\_map\_additional\_iam\_roles) | Additional IAM roles to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_additional_iam_users"></a> [map\_additional\_iam\_users](#input\_map\_additional\_iam\_users) | Additional IAM users to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `"default"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | n/a | `string` | n/a | yes |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_use_legacy_eks_name"></a> [use\_legacy\_eks\_name](#input\_use\_legacy\_eks\_name) | Use the legacy EKS naming convention: dev-default-cluster | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_role_arn"></a> [admin\_role\_arn](#output\_admin\_role\_arn) | n/a |
| <a name="output_db_subnet_group"></a> [db\_subnet\_group](#output\_db\_subnet\_group) | n/a |
| <a name="output_eks"></a> [eks](#output\_eks) | n/a |
| <a name="output_eks_context"></a> [eks\_context](#output\_eks\_context) | n/a |
| <a name="output_vpc"></a> [vpc](#output\_vpc) | n/a |
<!-- END_TF_DOCS -->