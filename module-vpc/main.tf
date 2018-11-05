resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "public" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.vpc_name}-${var.public_subnet_tags}-${element(var.azs, 0)}"
  }
}

resource "aws_subnet" "private" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.vpc_name}-${element(var.azs, 1)}"
  }
}

resource "aws_route_table" "public" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.vpc_name}-${var.public_route_table_tags}"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"

  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table" "private" {
  count = "${length(var.private_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets) > 0 ? length(var.public_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

locals {
  nat_gateway_ips = "${split(",", (var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id)))}"
}

resource "aws_eip" "nat" {
  count = "${(var.enable_nat_gateway && !var.reuse_nat_ips) ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"

  vpc = true

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.vpc_name, element(var.azs, (var.single_nat_gateway ? 0 : count.index)))))}"
}


resource "aws_nat_gateway" "this" {
  count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"

  allocation_id = "${element(local.nat_gateway_ips, (var.single_nat_gateway ? 0 : count.index))}"
  subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"

  tags = "${merge(var.tags, map("Name", format("%s-%s", var.vpc_name, element(var.azs, (var.single_nat_gateway ? 0 : count.index)))))}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_route" "private_nat_gateway" {
  count = "${var.enable_nat_gateway ? 1 : 0}"

  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.this.*.id, count.index)}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private.*.id}"
}