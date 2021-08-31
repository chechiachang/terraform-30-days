# Get Started

In this session you will learn
- Prerequisite
- Basic Terraform command

# Prerequisite

This lecture will walk you through Terraform with examples to manage public cloud resources. Students are required to have access to one valid account to public cloud
- aws
- azure
- gcp

For beginner, we suggest to use public cloud Free Tier to minimize the cost. Here are some guide to access Free Tier Account
- aws
- azure
- gcp

This session we will use Azure Cloud as main example. No matter which cloud provider you use, the concepts in this session are all the same.

```
brew install azure-cli

az version
```

# Hello Azure

Let's check the content

Use your favorate editor to edit terraform.tf
```
```

### First Terraform Command 

```
cd azure/foundation
```

```
az login

[{
    "cloudName": "AzureCloud",
    "homeTenantId": "1234567-my-home-tenant-id",
    "id": "1234567-my-id",
    "isDefault": true,
    "managedByTenants": [],
    "name": "my-subscription",
    "state": "Enabled",
    "tenantId": "1234567-my-tenant-id",
    "user": {
      "name": "my-email",
      "type": "my-user"
    }
}]
```

```
terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 2.65"...
- Installing hashicorp/azurerm v2.65.0...
- Installed hashicorp/azurerm v2.65.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```

# Add Resource group / Storage Account / Container


```
terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "southeastasia"
      + name     = "terraform-30-days"
    }

  # azurerm_storage_container.main will be created
  + resource "azurerm_storage_container" "main" {
      + container_access_type   = "private"
      + has_immutability_policy = (known after apply)
      + has_legal_hold          = (known after apply)
      + id                      = (known after apply)
      + metadata                = (known after apply)
      + name                    = "tfstate"
      + resource_manager_id     = (known after apply)
      + storage_account_name    = "tfstate"
    }
  ...

Plan: 3 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────
```

# Apply

```
terraform apply

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

NOTE: Always double check before type yes.


# Terraform local files

```
ls -al

drwxr-xr-x  .terraform
-rw-r--r--  .terraform.lock.hcl
-rw-r--r--  main.tf
-rw-r--r--  output.tf
-rw-r--r--  terraform.tfstate
-rw-r--r--  terraform.tfstate.backup
```

These files have special purposes to execute Terraform. They are hidden and ignored by git. You can ignore these files for now. We will discuss 
- Terraform Lock in [Session ?: Backends]()
- Terraform state in [Session ?: State]()

```
terrafrom plan

```

It's much longer than last plan. Still we should pay attention about the content.

NOTE: Usually, plan with 0 to change and  0 to destroy will do no harm to your existing resources. I.E. it won't kill your running production sites. However, it's a good habit to review each plan before apply. 

# Debug

### Potential Error: name is already taken

```
╷
│ Error: Error creating Azure Storage Account "tfstate": storage.AccountsClient#Create: Failure sending request: StatusCode=0 -- Original Error: autorest/azure: Service returned an error. Status=<nil> Code="StorageAccountAlreadyTaken" Message="The storage account named tfstate is already taken."
│
│   with azurerm_storage_account.main,
│   on storage_account.tf line 1, in resource "azurerm_storage_account" "main":
│    1: resource "azurerm_storage_account" "main" {
│
╵
```

Lets' google 'terraform azure storage account'
- [Official doc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)

```
name - (Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group.
```

Basic Debug 3 steps: Google, read document, retry.

### About random

Will see more in the future lectures.

# Remove Storage Container

Use your favorate editor to edit `azure/foundation/storage_account.tf` file

```
vim azure/foundation/storage_account.tf
```

Add comment in front of storage container block. Like

```
...
#resource "azurerm_storage_container" "main" {
#  name                  = "tfstate"
#  storage_account_name  = azurerm_storage_account.main.name
#  container_access_type = "private"
#}
...
```

Let's plan again and see what happen.
```
terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_storage_container.main will be destroyed
  - resource "azurerm_storage_container" "main" {
      - container_access_type   = "private" -> null
      - has_immutability_policy = false -> null
      - has_legal_hold          = false -> null
      - id                      = "https://tfstatef4380b8b1152083e.blob.core.windows.net/tfstate" -> null
      - metadata                = {} -> null
      - name                    = "tfstate" -> null
      - resource_manager_id     = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days/providers/Microsoft.Storage/storageAccounts/tfstatef4380b8b1152083e/blobServices/default/containers/tfstate" -> null
      - storage_account_name    = "tfstatef4380b8b1152083e" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.
```


Warning: the terraform is about to delete your storage container. This is exactly what we want. So
- double check the resources to destroy. 1 to destroy, which is correct. We don't want Terraform to delete extra resources.
- There could be some side effects about this destroy. For example, if you delete storage account, the storage container will also be deleted because the storage container depends on storage account. This is called resources dependency. Will cover this later.

Now, apply
```
terraform apply

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

And the storage container is gone.

# Homework

Now, try the following practice

1. Add Storage Container back
1. Try other resources in `azure/poc`
  - Make some changes to variables. ex. rename resources. Then apply.
1. Check State
  - Use your favorate editor to check content of `terraform.tfstate` file
  - Try terraform destroy
  - After destroy, check `terraform.tfstate` again

# Summary

So far, we know that Terraform somehow 'sync' the desired resources in local .tf files to cloud states. Terraform will ask to create a new resource if there's a new resource block, delete an existing resource if cloud state has more resources than local .tf files.

Basically
- three steps: init, plan, apply
- More tf than state -> add. Less tf than state -> delete.
- Terraform is declarative: write final resources, provider (discuss in session ?) will handle how to reconcile resources & states
- A good habit: always review plan before apply, especially destroy.

- https://azure.microsoft.com/zh-tw/free/free-account-faq/
