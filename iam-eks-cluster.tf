#----------------------------------------------------------------------------------------------------------------------
# EKS Cluster IAM Role and Policies To Attach To The Role
#----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "cluster" {
  name = "${var.aws_k8s_cluster}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# provides Kubernetes the permissions it requires to manage resources on your behalf
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# allows Amazon Elastic Container Service for Kubernetes to create and manage the necessary resources to operate EKS Clusters
resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

# allows Amazon Elastic Container Service for Kubernetes to create and manage the necessary resources to operate EKS Clusters
resource "aws_iam_role_policy_attachment" "cluster-AmazonCloudWatchPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.cluster.name
}
