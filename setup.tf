 terraform {

   required_version = "1.0.11"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.80.0"
     }
   }
 }