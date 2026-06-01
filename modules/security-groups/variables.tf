variable "vpc_id" {
  type = string
}

variable "ssh_allowed" {
  description = "SSH access rules (name + ip)"

  type = object({
    rule_name = string
    ip        = string
  })
}
