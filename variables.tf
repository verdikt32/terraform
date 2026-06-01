variable "ssh_allowed" {
  description = "SSH access rules (name + ip)"

  type = object({
    rule_name = string
    ip        = string
  })

  default = {
    rule_name = "my-ip"
    ip        = "37.215.33.150/32"
  }
}
