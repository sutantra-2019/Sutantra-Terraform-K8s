locals {
  #node_sec_group = [var.source_security_group_ids, data.aws_security_group.node.id]
  node_sec_group = [data.aws_security_group.node.id]
}


resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.aws_k8s_cluster
  node_group_name = "${var.aws_k8s_cluster}-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnet_ids.public_subnet_ids.ids

  release_version      = var.ami_release_version
  version              = var.kubernetes_version
  force_update_version = var.force_update_version

  ami_type       = var.ami_type
  instance_types = [var.aws-node-instance-type]

  remote_access {
    ec2_ssh_key = var.worker_node_key
  }

  scaling_config {
    desired_size = var.desired-capacity
    max_size     = var.max-size
    min_size     = var.min-size
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.eks,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy
  ]

  tags = merge(
    {
      "Name" = "${var.aws_k8s_cluster}-Node-Group"
    },
    var.tags
  )
}
