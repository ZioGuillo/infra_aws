terraform {
  source = "${get_terragrunt_dir()}../../../../../../modules//lambda-app"
}

include {
  path = find_in_parent_folders()
}

#dependency "" { 
#}

#inputs = {  
#}