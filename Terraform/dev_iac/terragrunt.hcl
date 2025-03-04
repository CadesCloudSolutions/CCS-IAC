include "root" {
    path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
    source = "git::https://github.com//repo.git//terraform?ref=<branch-or-tag>"
}

remote_state {
    backend = "azurem"
    config = {
        resource_group_name = "rg-terraform-state"
        storage_account_name = "tfstateaccount"
        container_name = "tfstate"
        key = "prod/terraform.tfstate"
    }
      
}

inputs = {
    env_name = "prod"
    resource_group_name = "rg-"
    contributor_principal_id = "xxxx-xxxx" # Prod Admins group 
    reader_principal_id = "xxxx-xx" # Auditors group 
    developer_principal_id = "xxx-xxxx" # Devs
}