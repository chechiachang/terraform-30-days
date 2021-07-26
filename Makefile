validate:
	terraform validate .

fmt:
	terraform fmt .

# terratest

go-init:
	go mod init github.com/chechiachang/terraform-30-days

test: test-azure # aws gcp

.PHONY: test

# Azure

ARM_SUBSCRIPTION_ID = $(shell cat ~/.azure/azureProfile.json | jq -r '.subscriptions[-1].id')

test-azure:
	GO111MODULE=on ARM_SUBSCRIPTION_ID=$(ARM_SUBSCRIPTION_ID) go test -v ./azure/test

.PHONY: test-azure
