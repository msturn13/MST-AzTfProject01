variable "region" {
  type    = string
  default = "Central US"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "nic" {
  type    = list(string)
  default = ["vm-nic01", "vm-nic02"]

}

