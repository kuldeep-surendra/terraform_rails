resource "aws_security_group" "this" {

  name        = "${var.security_group_name}"
  description = "${var.security_group_description}"
  vpc_id      = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.security_group_name)))}"
}

resource "aws_security_group_rule" "ingress_rules_without_source_security_group" {
  count = "${length(var.ingress_with_cidr_blocks) > 0 ? length(var.ingress_with_cidr_blocks) : 0}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "ingress"

  cidr_blocks     = ["${split(",", lookup(var.ingress_with_cidr_blocks[count.index], "cidr_blocks", join(",", var.ingress_cidr_blocks)))}"]
  ipv6_cidr_blocks = ["${var.ingress_ipv6_cidr_blocks}"]
  prefix_list_ids  = ["${var.ingress_prefix_list_ids}"]
  description     = "${lookup(var.ingress_with_cidr_blocks[count.index], "description", "Ingress Rule")}"

  from_port = "${lookup(var.ingress_with_cidr_blocks[count.index], "from_port", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 0))}"
  to_port   = "${lookup(var.ingress_with_cidr_blocks[count.index], "to_port", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 1))}"
  protocol  = "${lookup(var.ingress_with_cidr_blocks[count.index], "protocol", element(var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")], 2))}"
}

resource "aws_security_group_rule" "egress_rules_without_source_security_group" {
  count = "${length(var.egress_with_cidr_blocks) > 0 ? length(var.egress_with_cidr_blocks) : 0}"

  security_group_id = "${aws_security_group.this.id}"
  type              = "egress"

  cidr_blocks     = ["${split(",", lookup(var.egress_with_cidr_blocks[count.index], "cidr_blocks", join(",", var.egress_cidr_blocks)))}"]
  ipv6_cidr_blocks = ["${var.egress_ipv6_cidr_blocks}"]
  prefix_list_ids  = ["${var.egress_prefix_list_ids}"]
  description     = "${lookup(var.egress_with_cidr_blocks[count.index], "description", "egress Rule")}"

  from_port = "${lookup(var.egress_with_cidr_blocks[count.index], "from_port", element(var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")], 0))}"
  to_port   = "${lookup(var.egress_with_cidr_blocks[count.index], "to_port", element(var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")], 1))}"
  protocol  = "${lookup(var.egress_with_cidr_blocks[count.index], "protocol", element(var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")], 2))}"
}

output "sg_id" {
  value = "${aws_security_group.this.id}"
}