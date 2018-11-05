terraform {
  required_version = "0.11.6"

  # backend "s3" {
  #   bucket = "terraform-state-railsapp"
  #   region = "ap-south-1"
  #   key    = "railsapp-state"
  # }
}

module "vpc" {
  source = "module-vpc"
  vpc_cidr = "10.0.0.0/16"

  vpc_name = "terraform-rails"

  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  azs = ["ap-south-1a", "ap-south-1b"]
  public_subnet_tags = "public_subnet"

  public_route_table_tags = "public-route-table"
}

module "security_group_appServer" {
  source = "module-security_group"

  security_group_name        = "terraform-rails-AppServer"
  security_group_description = "App server Security Group"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      description = "All ip"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      description = "All ip"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "ssh-tcp"
      description = "All ip"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "elb" {
  source = "module-elb"
  name = "terraform-rails-elb"
  subnets = ["${module.vpc.public_subnet_id[1]}", "${module.vpc.public_subnet_id[0]}"]
  security_groups = ["${module.security_group_appServer.sg_id}"]
  internal = false
  listener = [
    {
      instance_port     = "80"
      instance_protocol = "TCP"
      lb_port           = "80"
      lb_protocol       = "TCP"
    }
  ]
  health_check = [
    {
      target              = "TCP:80"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

}

data "template_file" "user_data" {
  template = "${file("templates/user_data.sh")}"
}

module "autoscaling" {
  source = "module-asg"
  name = "terraform-rails-AppServer-asg"

  lc_name = "terraform-rails-lc"
  image_id = "ami-0dc2e304f67060308"
  instance_type   = "t2.micro"
  security_groups = ["${module.security_group_appServer.sg_id}"]
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]
  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]
  user_data                 = "${data.template_file.user_data.rendered}"
  asg_name                  = "terraform-rails-asg"
  vpc_zone_identifier       = ["${module.vpc.public_subnet_id[0]}"]
  health_check_type         = "ELB"
  load_balancers            = ["${module.elb.elb_id}"]
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key_name                  = "kuldeep"
  enable_monitoring         = false

}
