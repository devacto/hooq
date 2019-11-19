output "frontend_elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = module.frontend_elb.this_elb_dns_name
}