Terraform 使用 Google Cloud Platform

Prerequiesites
- 一個 google account
- 一個 Gcloud billing account
  - 需要綁定信用卡
  - 需要啟用計費
- gcloud SDK
  - 登入
  - 有效的 project

# Gcloud SDK

[下載並安裝 gcloud sdk](https://cloud.google.com/sdk/docs/install)

```
VERSION=351.0.0
OS=darwin
ARCH=x86_64

cd # home
wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${VERSION}-${OS}-${ARCH}.tar.gz"

tar -zxf google-cloud-sdk-${VERSION}-${OS}-${ARCH}.tar.gz
ls google-cloud-sdk/bin
```

把下面這端加到 ~/.bashrc 或 ~/.zshrc
```
# Google SDK
export PATH="$PATH:/Users/${USER}/google-cloud-sdk/bin"
if [ -f '/Users/${USER}/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/${USER}/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/${USER}/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/${USER}/google-cloud-sdk/completion.zsh.inc'; fi
```

# Gcloud config

進行 gcloud init
- 設定本地 config 檔案
- 透過 web browser 登入 google 帳號
- 產生 gcloud project，容納所有雲端資源 (很不精確的描述，類似 azure resource group 與 aws account)
  - 可能需要選擇不同 project 名稱

```
gcloud init

Pick configuration to use:
 [1] Create a new configuration

Choose the account you would like to use to perform operations for
this configuration:
 [1] Log in with a new account

You are logged in as: [chechia@chechia.net].

Pick cloud project to use:
 [1] Create a new project

Enter a Project ID. Note that a Project ID CANNOT be changed later.
Project IDs must be 6-30 characters (lowercase ASCII, digits, or
hyphens) in length and start with a lowercase letter. terraform-30-days
```

# Provision GCS Terraform Backend (foundation)

為了產生 foundation 我們使用 root account
- 建立 google bucket storage
- 建立 terraform 專屬的 service account
  - 避免使用 root user account 執行 Terraform 權限太大
  - 避免在本機留下 local credential，十分不安全
- 只有在初始化 GCS backend 才使用 owner account，其他時間使用 terraform service account

本地產生 credential
```
gcloud auth application-default login
Credentials saved to file: [~/.config/gcloud/application_default_credentials.json]
```

```
cd gcp/foundation/us-west1/terraform_backend
terraform init
terraform plan
terraform apply
```

# Use service account

- 使用 `gcp/foundation/us-west1/terraform_backend` 產生
  - service account
  - local service accoint credential json key
- 目前的 terragrunt module 會使用本地 credential key

# Example: vpc networking

```
cd gcp/foundation/compute_network

terragrunt init
terragrunt plan
terragrunt apply
```
