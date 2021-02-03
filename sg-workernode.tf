module "node-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

  name        = "eks-node-sg"
  description = "EKS node security groups"
  vpc_id      = var.aws_vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]
  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 1025
      to_port                  = 65535
      protocol                 = "tcp"
      description              = "Allow EKS Control Plane"
      source_security_group_id = module.cluster-sg.this_security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name                                           = "${var.aws_k8s_cluster}-eks-node-sg"
    "kubernetes.io/cluster/${var.aws_k8s_cluster}" = "owned"
  }
}

# Bastion Security group
module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

  name        = "ssh-sg"
  description = "Security group which is to allow SSH from Bastion"
  vpc_id      = var.aws_vpc_id

  ingress_cidr_blocks = ["172.17.250.113/32"]
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}
