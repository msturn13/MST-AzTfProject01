 terraform {

   required_version = "1.0.11"

    backend "azurerm" {
    resource_group_name  = "mst-terraform"
    storage_account_name = "mstterraformcus"
    container_name       = "mst-aztfproject01"
    key                  = "project01.terraform.tfstate"
  }

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.80.0"
     }
   }
 }

#Create Resource Group
 resource "azurerm_resource_group" "rg" {
  name     = "mst-cus-rg"
  location = var.region
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
    name    = "mst-cus-vnet01"
    resource_group_name =   azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    address_space  = ["10.0.0.0/16"]

}

#vNet subnets 
resource "azurerm_subnet" "test_subnet" {
    name = "${lookup(element(var.subnet_prefix, count.index), "name")}"
    count = "${length(var.subnet_prefix)}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix = "${lookup(element(var.subnet_prefix, count.index), "ip")}"
}

#Create Availability Set
resource "azurerm_availability_set" "aset" {
  name                = "mst-cus-aset01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create Network Interface
resource "azurerm_network_interface" "nic" {
    count = var.node_count
    name = each.value
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}