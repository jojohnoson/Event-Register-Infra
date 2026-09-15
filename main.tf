module "sg" {
  source = "./modules/Security_Groups"
  
  alb_name = var.alb_name
  vpc_id   = module.vpc.vpc_id
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr
  sub1_cidr_block = var.root_sub1_cidr
  sub2_cidr_block = var.root_sub2_cidr
  sub1_az        = var.root_sub1_az
  sub2_az        = var.root_sub2_az
}

module "web_server-1" {
  source = "./modules/ec2_instance"

  vpc_id             = module.vpc.vpc_id
  subnet_id          = module.vpc.sub1_id
  sg                 = [module.sg.ec2_sg_id]
  ec2_type           = lookup(var.type, terraform.workspace, "t3.micro")
  associate_public_ip = true
  alb_name           = var.alb_name
  instance_name      = var.server_1
  key_pair           = var.key_access
}

module "web_server-2" {
  source = "./modules/ec2_instance"

  vpc_id             = module.vpc.vpc_id
  sg                 = [module.sg.ec2_sg_id]
  subnet_id          = module.vpc.sub2_id
  key_pair           = var.key_access
  depends_on         = [module.vpc]
  alb_name           = var.alb_name
  associate_public_ip = false
  instance_name      = var.server_2
  ec2_type           = lookup(var.type, terraform.workspace, "t3.micro")
}

module "alb" {
  source = "./modules/alb"

  alb_name       = var.alb_name
  subnets        = [module.vpc.sub1_id, module.vpc.sub2_id]
  security_group = [module.sg.alb_sg_id]
  vpc_id         = module.vpc.vpc_id

  instance_ids = {
    web1 = module.web_server-1.instance_id
    web2 = module.web_server-2.instance_id
  }
}
