# Create VPC peering connection.
data "aws_vpc" "exafunction_vpc" {
  id = var.vpc_id
}

data "aws_vpc" "peer_vpc" {
  id = var.peer_vpc_id
}

resource "aws_vpc_peering_connection" "exafunction" {
  vpc_id        = var.vpc_id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = data.aws_vpc.peer_vpc.owner_id
  auto_accept   = true
  tags = {
    "Name" = "exafunction-vpc-peering-connection"
  }
}

# Create route table routes.
resource "aws_route" "exafunction" {
  count = length(var.route_table_ids)
  depends_on = [
    aws_vpc_peering_connection.exafunction,
  ]
  route_table_id            = var.route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.peer_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.exafunction.id
}

resource "aws_route" "peer" {
  count = length(var.peer_route_table_ids)
  depends_on = [
    aws_vpc_peering_connection.exafunction,
  ]
  route_table_id            = var.peer_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.exafunction_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.exafunction.id
}

# Create security group rule.
resource "aws_security_group_rule" "exafunction_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.peer_vpc.cidr_block]
  security_group_id = var.security_group_id
}
