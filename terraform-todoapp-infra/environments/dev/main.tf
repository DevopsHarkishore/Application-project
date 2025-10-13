locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "dev"
  }
}


module "rg" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-dev-Todoproject-01"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrdevtodoproject01"
  rg_name    = "rg-dev-Todoproject-01"
  location   = "centralindia"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../../modules/azurerm_sql_server"
  sql_server_name = "sql-dev-todoapp-01"
  rg_name         = "rg-dev-Todoproject-01"
  location        = "centralindia"
  admin_username  = "devopsadmin"
  admin_password  = "P@ssw01rd@123"
  tags            = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-dev-todoproject"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = local.common_tags
}

module "aks" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_kubernetes_cluster"
  aks_name   = "aks-dev-todoproject"
  location   = "centralindia"
  rg_name    = "rg-dev-Todoproject-01"
  dns_prefix = "aks-dev-todoproject"
  tags       = local.common_tags
}


module "pip" {
  source   = "../../modules/azurerm_public_ip"
  depends_on = [ module.rg ]
  pip_name = "pip-dev-todoproject"
  rg_name  = "rg-dev-Todoproject-01"
  location = "centralindia"
  sku      = "Standard"
  tags     = local.common_tags
}
