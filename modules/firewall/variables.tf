# Variables for firewall module

variable "vpc_name" {
  type = string
}

variable "allow_ssh_source" {
  type        = list(string)
  description = "CIDR ranges allowed for SSH"
  default     = ["0.0.0.0/0"] # ⚠️ not safe for prod
}

variable "allow_http_https_source" {
  type        = list(string)
  description = "CIDR ranges allowed for HTTP/HTTPS"
  default     = ["0.0.0.0/0"]
}

variable "ssh_target_tag" {
  type        = string
  description = "Target tag for SSH firewall rule"
  default = "ssh-access"
}

variable "http_target_tag" {
  type        = string
  description = "Target tag for HTTP/HTTPS firewall rule"
  default = "http-access"
}

