## History

This module was forked from
<https://github.com/cloudposse/terraform-aws-eks-cluster> to
<https://github.com/hivewatch/terraform-aws-eks-cluster>.

Then it was changed in the
[`joncon/provider`](https://github.com/hivewatch/terraform-aws-eks-cluster/tree/joncon/provider)
branch.

Later, it was copied into the present repository.

## Notes

The original module has a
[page](https://registry.terraform.io/modules/cloudposse/eks-cluster/aws/latest)
in the Terraform Registry.

The purpose of forking the module
was to remove the `kubernetes` provider.
See [this commit](https://github.com/hivewatch/terraform-aws-eks-cluster/commit/1624e86b114e97d558321cff13284cdb97aa9811).
