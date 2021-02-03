data "aws_security_group" "cluster" {
  vpc_id = var.aws_vpc_id
  name   = module.cluster-sg.this_security_group_name
}

data "aws_security_group" "node" {
  vpc_id = var.aws_vpc_id
  name   = module.node-sg.this_security_group_name
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = var.aws_vpc_id
  tags = {
    Type = "Private"
  }
}
