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
