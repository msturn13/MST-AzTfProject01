terraform {

  required_version = "1.0.11"



required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~>2.80.0"
  }
 }
}

provider "azurerm" {
  features {}
}

data "terraform_remote_state" "projectremotestate" {
  backend = "azurerm"
  config = {
    storage_account_name = "mstterraformcus"
    container_name       = "mst-aztfproject01"
    key                  = "project01.terraform.tfstate"
  }
}

#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "mst-cus-rg"
  location = var.region
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "mst-cus-vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]

}

#vNet subnets 
resource "azurerm_subnet" "sn01" {
  name                 = "mst-cus-vnet01-sn01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "sn02" {
  name                 = "mst-cus-vnet01-sn02"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "sn03" {
  name                 = "mst-cus-vnet01-sn03"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "sn04" {
  name                 = "mst-cus-vnet01-sn04"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

#Create Availability Set
resource "azurerm_availability_set" "aset" {
  name                = "mst-cus-aset01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Create Load Balancer IP
resource "azurerm_public_ip" "lbpip" {
  name                = "mst-cus-pip01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

#Create Load Balancer
resource "azurerm_lb" "lb" {
  name                = "mst-cus-lb01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

#Create Load Balancer Backend
resource "azurerm_lb_backend_address_pool" "lbbackend" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "lb01-backened01"
}
# Create Network Interface
resource "azurerm_network_interface" "nic" {
  count               = var.node_count
  name                = "vm-nic${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "vmconfiguration"
    subnet_id                     = azurerm_subnet.sn01.id
    private_ip_address_allocation = "dynamic"
  }
}