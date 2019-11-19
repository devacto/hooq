variable "environment" {
  type        = string
  description = "Development, Staging, or Production."
  default     = "development"
}

variable "api_dns" {
  type        = string
  description = "DNS of the api server."
}

variable "frontend_dns" {
  type        = string
  description = "DNS of the frontend server."
}