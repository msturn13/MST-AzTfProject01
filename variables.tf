variable "region" {
  type = string
  default = "Central US"
}

variable "subnet_prefix" {
  type = "list"
  default = [
    {
      ip      = "10.0.0.0/24"
      name     = "subnet-1"
    },
    {
      ip      = "10.0.1.0/24"
      name     = "subnet-2"
    },
    {
      ip      = "10.0.2.0/24"
      name     = "subnet-1"
    },
    {
      ip      = "10.0.3.0/24"
      name     = "subnet-1"
    }
   ]
}