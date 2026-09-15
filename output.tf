output "server1_ip" {
  value = module.web_server-1.public_ip
}

output "server2_ip" {
  value = module.web_server-2.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "alb_dns" {
  value = module.alb.alb_dns
}

