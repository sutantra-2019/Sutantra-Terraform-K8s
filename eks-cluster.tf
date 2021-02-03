locals {
  enabled = true

  cluster_encryption_config = {
    resources        = var.cluster_encryption_config_resources
    provider_key_arn = local.enabled && var.cluster_encryption_config_enabled && aws_kms_key.Key-K8s-Cluster.arn == "" ? join("", aws_kms_key.Key-K8s-Cluster.arn) : aws_kms_key.Key-K8s-Cluster.arn
  }
}

resource "aws_eks_cluster" "eks" {

  name = var.aws_k8s_cluster

  # Version of the EKS Cluster Master i.e. 1.18
  version = var.aws_k8s-version

  # EKS Cluster IAM Service Role
  role_arn = aws_iam_role.cluster.arn

  # Cluster Encryption Config Enabled With KMS Key
  dynamic "encryption_config" {
    for_each = var.cluster_encryption_enabled ? [local.cluster_encryption_config] : []
    content {
      resources = var.cluster_encryption_config_resources
      provider {
        key_arn = aws_kms_key.Key-K8s-Cluster.arn
      }
    }
  }

  vpc_config {
    security_group_ids      = [data.aws_security_group.cluster.id]
    subnet_ids              = data.aws_subnet_ids.public_subnet_ids.ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  #------------------------------------------------------------------------------------------------------
  # Cloud watch logging enabling for "api", "audit", "authenticator", "controllerManager", "scheduler"
  #------------------------------------------------------------------------------------------------------
  enabled_cluster_log_types = var.aws_k8s_cw_logging

  tags = merge(
    {
      "Name" = "${var.aws_k8s_cluster}-Cluster"
    },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.cluster-AmazonCloudWatchPolicy
  ]
}
