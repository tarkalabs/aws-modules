resource "aws_security_group" "main" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags = var.tags
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  type        = "ingress"
  security_group_id = aws_security_group.main.id

  count       = length(var.ingress_ports_and_cidr_blocks)

  from_port   = var.ingress_ports_and_cidr_blocks[count.index].from_port
  to_port     = var.ingress_ports_and_cidr_blocks[count.index].to_port
  cidr_blocks = split(",", var.ingress_ports_and_cidr_blocks[count.index].cidr_blocks)
  protocol    = var.ingress_ports_and_cidr_blocks[count.index].protocol
}

resource "aws_security_group_rule" "egress_cidr_blocks" {
  type        = "egress"
  security_group_id = aws_security_group.main.id

  count       = length(var.egress_ports_and_cidr_blocks)

  from_port   = var.egress_ports_and_cidr_blocks[count.index].from_port
  to_port     = var.egress_ports_and_cidr_blocks[count.index].to_port
  cidr_blocks = split(",", var.egress_ports_and_cidr_blocks[count.index].cidr_blocks)
  protocol    = var.egress_ports_and_cidr_blocks[count.index].protocol
}
