variable "region" {
  type = string
  default = "Central US"
}

variable "subnet_prefix" {
  type = "list"
  default = [
    {
      ip      = "10.0.0.0/24"
      name     = "mst-cus-vnet01-sn01"
    },
    {
      ip      = "10.0.1.0/24"
      name     = "mst-cus-vnet01-sn02"
    },
    {
      ip      = "10.0.2.0/24"
      name     = "mst-cus-vnet01-sn03"
    },
    {
      ip      = "10.0.3.0/24"
      name     = "mst-cus-vnet01-sn04"
    }
   ]
}

variable "node_count" {
type = number
default = 2
}

variable "nic" {
  type        = list(string)
  default     = ["vm-nic01","vm-nic02"]

}

