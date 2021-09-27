
本章介紹如何使用 terratest 為 terraform 準備整合測試

# Terratest

[Terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/) 是一個 infrastructure 的自動化測試 go library
- 以 golang 為語言
- 整合各家公有雲的 API，以及開源服務如 Kubernetes API，helm
- 已經整合 terraform，Packer 或是 Docker，可以直接測試各服務的程式碼

# Test terraform with terratest

[Terratest 文件說明測試 terraform code 的基本流程](https://terratest.gruntwork.io/docs/getting-started/quick-start/#terratest-intro)
- 使用 golang 內建的 package test，寫出測試案例 `_test.go`
- 在 golang 中使用 terratest 來呼叫需要測試的 terraform .tf 檔案，實際去公有雲產生測試用 infrastructure
- 使用 terratest 提供的工具來驗證產生出來的 infrastructure
- 測試完成後，清除所有產生的 infrastructure

# prerequisite

使用 terratest 測試為一個需求就是 golang
- [取得並安裝 golang](https://golang.org/dl/)
- [依照 terratest 說明設定 repository](https://terratest.gruntwork.io/docs/getting-started/quick-start/)

# example

實際舉例：這邊有為 `azure/_poc/foundation` 寫測試例

```
cd azure

tree -L 1
.
├── ...
├── _poc
└── test
```

實際到 `azure/test/poc_foundation_test.go`

```
// https://github.com/gruntwork-io/terratest/blob/master/test/azure/terraform_azure_resourcegroup_example_test.go
package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	//"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureResourceGroupExample(t *testing.T) {
	t.Parallel()

	// subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	subscriptionID := ""
	//uniquePostfix := random.UniqueId()

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../_poc/foundation",
	}

	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	storageAccountName := terraform.Output(t, terraformOptions, "storage_account_name")
	storageContainerName := terraform.Output(t, terraformOptions, "storage_container_name")

	// website::tag::4:: Verify the resource group exists
	assert.True(t,
		azure.ResourceGroupExists(t, resourceGroupName, subscriptionID),
		"Resource group does not exist")
	assert.True(t,
		azure.StorageAccountExists(t, storageAccountName, resourceGroupName, subscriptionID),
		"Storage Account does not exist")
	assert.True(t,
		azure.StorageBlobContainerExists(t, storageContainerName, storageAccountName, resourceGroupName, subscriptionID),
		"Storage Container does not exist")
}
```

這個測試非常單純
- 設定 `terraformOptions.TerraformDir` 的 directory 位置為希望測試的 root module
- 呼叫 `terraform.InitAndApply(t, terraformOptions)` 實際 apply
- 取得 terraform.Output，從 terraform.Output 中檢查產生的 output 內容是否符合預期
- 在 assert.True 中，使用 azure API 檢查 infrastructure 是否存在，例如以 `azure.ResourceGroupExist` 檢查公有雲上是否真的有指定名稱的 resourcegroup
- 可以透過 azure API 針對 infrastructure 細節做檢查
- 完成後 `defer terraform.Destroy(t, terraformOptions)` 清除所有產生的 infrastructure

# Run test

接下來我們實際執行測試

- 注意 `azure/_poc/foundation` 的內容，是沒有 terragrunt 的 terraform
- 注意 `azure/_poc/foudnation` 的執行身份不是 service principal，而是剛開課時使用的 user az login credential

```
cd azure

az login

export ARM_SUBSCRIPTION_ID=""
go test ./test

go test -v ./test
=== RUN   TestTerraformAzureResourceGroupExample
=== PAUSE TestTerraformAzureResourceGroupExample
=== CONT  TestTerraformAzureResourceGroupExample
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:02+08:00 retry.go:91: terraform [init -upgrade=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:02+08:00 logger.go:66: Running command terraform with args [init -upgrade=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:02+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:02+08:00 logger.go:66: Initializing the backend...
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:03+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:03+08:00 logger.go:66: Initializing provider plugins...
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:03+08:00 logger.go:66: - Reusing previous version of hashicorp/azurerm from the dependency lock file
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:03+08:00 logger.go:66: - Reusing previous version of hashicorp/random from the dependency lock file
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: - Using previously-installed hashicorp/azurerm v2.65.0
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: - Using previously-installed hashicorp/random v3.1.0
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: Terraform has been successfully initialized!
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: You may now begin working with Terraform. Try running "terraform plan" to see
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: any changes that are required for your infrastructure. All Terraform commands
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: should now work.
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: If you ever set or change modules or backend configuration for Terraform,
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: rerun this command to reinitialize your working directory. If you forget, other
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: commands will detect it and remind you to do so if necessary.
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 retry.go:91: terraform [apply -input=false -auto-approve -lock=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:04+08:00 logger.go:66: Running command terraform with args [apply -input=false -auto-approve -lock=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66: Terraform used the selected providers to generate the following execution
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66: plan. Resource actions are indicated with the following symbols:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + create
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66: Terraform will perform the following actions:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   # azurerm_resource_group.rg will be created
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + resource "azurerm_resource_group" "rg" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + id       = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + location = "southeastasia"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + name     = "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   # azurerm_storage_account.main will be created
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + resource "azurerm_storage_account" "main" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + access_tier                      = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + account_kind                     = "StorageV2"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + account_replication_type         = "LRS"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + account_tier                     = "Standard"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + allow_blob_public_access         = false
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + enable_https_traffic_only        = true
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + id                               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + is_hns_enabled                   = false
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + large_file_share_enabled         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + location                         = "southeastasia"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + min_tls_version                  = "TLS1_2"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + name                             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + nfsv3_enabled                    = false
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_access_key               = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_blob_connection_string   = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_blob_endpoint            = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_blob_host                = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_connection_string        = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_dfs_endpoint             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_dfs_host                 = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_file_endpoint            = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_file_host                = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_location                 = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_queue_endpoint           = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_queue_host               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_table_endpoint           = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_table_host               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_web_endpoint             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + primary_web_host                 = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + resource_group_name              = "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_access_key             = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_blob_connection_string = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_blob_endpoint          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_blob_host              = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_connection_string      = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_dfs_endpoint           = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_dfs_host               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_file_endpoint          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_file_host              = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_location               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_queue_endpoint         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_queue_host             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_table_endpoint         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_table_host             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_web_endpoint           = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + secondary_web_host               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + tags                             = {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + "environment" = "foundation"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + blob_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + change_feed_enabled      = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + default_service_version  = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + last_access_time_enabled = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + versioning_enabled       = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + container_delete_retention_policy {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + cors_rule {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_methods    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_origins    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + exposed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + max_age_in_seconds = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + delete_retention_policy {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + identity {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + identity_ids = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + principal_id = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + tenant_id    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + type         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + network_rules {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + bypass                     = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + default_action             = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + ip_rules                   = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + virtual_network_subnet_ids = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + private_link_access {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + endpoint_resource_id = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + endpoint_tenant_id   = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + queue_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + cors_rule {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_methods    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_origins    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + exposed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + max_age_in_seconds = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + hour_metrics {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + enabled               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + include_apis          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + retention_policy_days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + version               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + logging {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + delete                = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + read                  = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + retention_policy_days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + version               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + write                 = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + minute_metrics {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + enabled               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + include_apis          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + retention_policy_days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + version               = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + routing {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + choice                      = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + publish_internet_endpoints  = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + publish_microsoft_endpoints = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + share_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + cors_rule {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_methods    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + allowed_origins    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + exposed_headers    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + max_age_in_seconds = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + retention_policy {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + days = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:           + smb {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + authentication_types            = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + channel_encryption_type         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + kerberos_ticket_encryption_type = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:               + versions                        = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   # azurerm_storage_container.main will be created
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + resource "azurerm_storage_container" "main" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + container_access_type   = "private"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + has_immutability_policy = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + has_legal_hold          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + id                      = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + metadata                = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + name                    = "tfstate"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + resource_manager_id     = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + storage_account_name    = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   # random_id.storage_account_name will be created
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + resource "random_id" "storage_account_name" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + b64_std     = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + b64_url     = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + byte_length = 8
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + dec         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + hex         = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:       + id          = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66: Plan: 4 to add, 0 to change, 0 to destroy.
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66: Changes to Outputs:
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + resource_group_name    = "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + storage_account_name   = (known after apply)
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:18+08:00 logger.go:66:   + storage_container_name = "tfstate"
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:19+08:00 logger.go:66: random_id.storage_account_name: Creating...
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:19+08:00 logger.go:66: random_id.storage_account_name: Creation complete after 0s [id=oVkUl07PTk8]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:29+08:00 logger.go:66: azurerm_resource_group.rg: Creating...
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:30+08:00 logger.go:66: azurerm_resource_group.rg: Creation complete after 1s [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:30+08:00 logger.go:66: azurerm_storage_account.main: Creating...
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:40+08:00 logger.go:66: azurerm_storage_account.main: Still creating... [10s elapsed]
TestTerraformAzureResourceGroupExample 2021-09-27T22:51:50+08:00 logger.go:66: azurerm_storage_account.main: Still creating... [20s elapsed]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:00+08:00 logger.go:66: azurerm_storage_account.main: Still creating... [30s elapsed]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: azurerm_storage_account.main: Creation complete after 31s [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc/providers/Microsoft.Storage/storageAccounts/tfstatea15914974ecf4e4f]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: azurerm_storage_container.main: Creating...
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: azurerm_storage_container.main: Creation complete after 0s [id=https://tfstatea15914974ecf4e4f.blob.core.windows.net/tfstate]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: Outputs:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: resource_group_name = "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: storage_account_name = "tfstatea15914974ecf4e4f"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: storage_container_name = "tfstate"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 retry.go:91: terraform [output -no-color -json resource_group_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:02+08:00 logger.go:66: Running command terraform with args [output -no-color -json resource_group_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:03+08:00 logger.go:66: "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:03+08:00 retry.go:91: terraform [output -no-color -json storage_account_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:03+08:00 logger.go:66: Running command terraform with args [output -no-color -json storage_account_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:04+08:00 logger.go:66: "tfstatea15914974ecf4e4f"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:04+08:00 retry.go:91: terraform [output -no-color -json storage_container_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:04+08:00 logger.go:66: Running command terraform with args [output -no-color -json storage_container_name]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:05+08:00 logger.go:66: "tfstate"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:09+08:00 retry.go:91: terraform [destroy -auto-approve -input=false -lock=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:09+08:00 logger.go:66: Running command terraform with args [destroy -auto-approve -input=false -lock=false]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:11+08:00 logger.go:66: random_id.storage_account_name: Refreshing state... [id=oVkUl07PTk8]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:21+08:00 logger.go:66: azurerm_resource_group.rg: Refreshing state... [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:22+08:00 logger.go:66: azurerm_storage_account.main: Refreshing state... [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc/providers/Microsoft.Storage/storageAccounts/tfstatea15914974ecf4e4f]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: azurerm_storage_container.main: Refreshing state... [id=https://tfstatea15914974ecf4e4f.blob.core.windows.net/tfstate]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Note: Objects have changed outside of Terraform
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Terraform detected the following changes made outside of Terraform since the
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: last "terraform apply":
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   # azurerm_resource_group.rg has been changed
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   ~ resource "azurerm_resource_group" "rg" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         id       = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         name     = "terraform-30-days-poc"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       + tags     = {}
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         # (1 unchanged attribute hidden)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Unless you have made equivalent changes to your configuration, or ignored the
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: relevant attributes using ignore_changes, the following plan may include
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: actions to undo or respond to these changes.
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: ─────────────────────────────────────────────────────────────────────────────
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Terraform used the selected providers to generate the following execution
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: plan. Resource actions are indicated with the following symbols:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - destroy
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Terraform will perform the following actions:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   # azurerm_resource_group.rg will be destroyed
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - resource "azurerm_resource_group" "rg" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - id       = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - location = "southeastasia" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - name     = "terraform-30-days-poc" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - tags     = {} -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   # azurerm_storage_account.main will be destroyed
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - resource "azurerm_storage_account" "main" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - access_tier                    = "Hot" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - account_kind                   = "StorageV2" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - account_replication_type       = "LRS" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - account_tier                   = "Standard" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - allow_blob_public_access       = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - enable_https_traffic_only      = true -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - id                             = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc/providers/Microsoft.Storage/storageAccounts/tfstatea15914974ecf4e4f" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - is_hns_enabled                 = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - location                       = "southeastasia" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - min_tls_version                = "TLS1_2" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - name                           = "tfstatea15914974ecf4e4f" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - nfsv3_enabled                  = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_access_key             = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_blob_connection_string = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_blob_endpoint          = "https://tfstatea15914974ecf4e4f.blob.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_blob_host              = "tfstatea15914974ecf4e4f.blob.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_connection_string      = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_dfs_endpoint           = "https://tfstatea15914974ecf4e4f.dfs.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_dfs_host               = "tfstatea15914974ecf4e4f.dfs.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_file_endpoint          = "https://tfstatea15914974ecf4e4f.file.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_file_host              = "tfstatea15914974ecf4e4f.file.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_location               = "southeastasia" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_queue_endpoint         = "https://tfstatea15914974ecf4e4f.queue.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_queue_host             = "tfstatea15914974ecf4e4f.queue.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_table_endpoint         = "https://tfstatea15914974ecf4e4f.table.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_table_host             = "tfstatea15914974ecf4e4f.table.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_web_endpoint           = "https://tfstatea15914974ecf4e4f.z23.web.core.windows.net/" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - primary_web_host               = "tfstatea15914974ecf4e4f.z23.web.core.windows.net" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - resource_group_name            = "terraform-30-days-poc" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - secondary_access_key           = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - secondary_connection_string    = (sensitive value)
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - tags                           = {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - "environment" = "foundation"
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         } -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - blob_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - change_feed_enabled      = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - last_access_time_enabled = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - versioning_enabled       = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - network_rules {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - bypass                     = [
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - "AzureServices",
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:             ] -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - default_action             = "Allow" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - ip_rules                   = [] -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - virtual_network_subnet_ids = [] -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - queue_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - hour_metrics {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - enabled               = true -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - include_apis          = true -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - retention_policy_days = 7 -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - version               = "1.0" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - logging {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - delete                = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - read                  = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - retention_policy_days = 0 -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - version               = "1.0" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - write                 = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - minute_metrics {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - enabled               = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - include_apis          = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - retention_policy_days = 0 -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - version               = "1.0" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - share_properties {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:           - retention_policy {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:               - days = 7 -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:             }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:         }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   # azurerm_storage_container.main will be destroyed
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - resource "azurerm_storage_container" "main" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - container_access_type   = "private" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - has_immutability_policy = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - has_legal_hold          = false -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - id                      = "https://tfstatea15914974ecf4e4f.blob.core.windows.net/tfstate" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - metadata                = {} -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - name                    = "tfstate" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - resource_manager_id     = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc/providers/Microsoft.Storage/storageAccounts/tfstatea15914974ecf4e4f/blobServices/default/containers/tfstate" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - storage_account_name    = "tfstatea15914974ecf4e4f" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   # random_id.storage_account_name will be destroyed
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - resource "random_id" "storage_account_name" {
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - b64_std     = "oVkUl07PTk8=" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - b64_url     = "oVkUl07PTk8" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - byte_length = 8 -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - dec         = "11626346553128472143" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - hex         = "a15914974ecf4e4f" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:       - id          = "oVkUl07PTk8" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:     }
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Plan: 0 to add, 0 to change, 4 to destroy.
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66: Changes to Outputs:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - resource_group_name    = "terraform-30-days-poc" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - storage_account_name   = "tfstatea15914974ecf4e4f" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:25+08:00 logger.go:66:   - storage_container_name = "tfstate" -> null
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:37+08:00 logger.go:66: azurerm_storage_container.main: Destroying... [id=https://tfstatea15914974ecf4e4f.blob.core.windows.net/tfstate]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:38+08:00 logger.go:66: azurerm_storage_container.main: Destruction complete after 2s
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:38+08:00 logger.go:66: azurerm_storage_account.main: Destroying... [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc/providers/Microsoft.Storage/storageAccounts/tfstatea15914974ecf4e4f]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:42+08:00 logger.go:66: azurerm_storage_account.main: Destruction complete after 3s
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:42+08:00 logger.go:66: azurerm_resource_group.rg: Destroying... [id=/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days-poc]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:42+08:00 logger.go:66: random_id.storage_account_name: Destroying... [id=oVkUl07PTk8]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:42+08:00 logger.go:66: random_id.storage_account_name: Destruction complete after 0s
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:52+08:00 logger.go:66: azurerm_resource_group.rg: Still destroying... [id=/subscriptions/6fce7237-7e8e-4053-8e7d-...e/resourceGroups/terraform-30-days-poc, 10s elapsed]
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:59+08:00 logger.go:66: azurerm_resource_group.rg: Destruction complete after 17s
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:59+08:00 logger.go:66:
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:59+08:00 logger.go:66: Destroy complete! Resources: 4 destroyed.
TestTerraformAzureResourceGroupExample 2021-09-27T22:52:59+08:00 logger.go:66:
--- PASS: TestTerraformAzureResourceGroupExample (117.23s)
PASS
ok  	github.com/chechiachang/terraform-30-days/azure/test	117.471s
```

使用 `go test --verbose` 查看完整的內容
- golang test 中，透過 terratest，會實際 init & plan & apply 內容
- 過程中透過 azure api 檢查產生內容
- 結束後 defer 清除測試用 infrastructure

# write test

如何寫出 `*_test.go`
- 如果對於 golang 十分熟系的人，可以直接寫測試案例
- 不熟悉的人可以直接參考 [terratest 提供的 example 做修改](https://github.com/gruntwork-io/terratest/blob/master/test/azure/terraform_azure_resourcegroup_example_test.go)
- 或是複製本 repository 的部分內容

```
├── azure
│   ├── _poc
│   └── test
├── go.mod
└── go.sum
```

# test or not test

團隊是否要寫 terratest？
- 自動化測試需要花時間寫
- 自動化測試隨著開發，會需要額外維護成本

承接上篇內容，請先完成成本比較低的測試
- 自動化 validate / format
- variable custom validation
- auto plan & auto apply

在與 app 的 end-to-end 做整合，作為 infrastructure functional test 的一部分

最後再考慮寫 terratest 的整合測試
- 如果發現使用的 module 非常複雜，可以考慮為這個 module 寫測試
- 如果發現花在 manual test 的時間成本越來越多，可以考慮將手動測試轉成自動化測試
