output "api_elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = module.api_elb.this_elb_dns_name
}