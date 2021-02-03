#----------------------------------------------------------------------------------------------------------------------
# IAM roles and Policy attachments to the Node Role.
#----------------------------------------------------------------------------------------------------------------------
resource "aws_iam_role" "node" {
  name = "${var.aws_k8s_cluster}-eks-node-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonSSMPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonCloudWatchPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AttachALBIngressPolicy" {
  policy_arn = "arn:aws:iam::${var.aws_account}:policy/${var.aws_k8s_cluster}-alb-policy"
  role       = aws_iam_role.node.name

  depends_on = [aws_iam_policy.eks_alb_policy]
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.aws_k8s_cluster}-eks-node-instance-profile"
  role = aws_iam_role.node.name
}
