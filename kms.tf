data "aws_caller_identity" "current" {}

resource "aws_kms_key" "Key-K8s-Cluster" {
  deletion_window_in_days  = 7
  tags                     = var.tags
  is_enabled               = var.kms_enabled
  enable_key_rotation      = var.enable_key_rotation
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  description              = "KMS Key for AWS EKS Cluster - ${var.aws_k8s_cluster}"
  policy                   = <<Policy
{
  "Version": "2012-10-17",
  "Id": "${var.aws_k8s_cluster}",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
Policy
}

resource "aws_kms_alias" "Key-K8s-Cluster" {
  name          = "alias/${var.aws_k8s_cluster}-K8s-Cluster"
  target_key_id = aws_kms_key.Key-K8s-Cluster.id
}
