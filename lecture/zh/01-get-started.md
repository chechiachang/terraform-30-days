本堂課程希望大家都能有 hands-on 動手做的經驗，也提供由淺入深的範例，幫助大家學習。

建議學習環境
- 一台本機電腦，Linux / Mac OS 為佳
  - windows 使用者請考慮使用 VM 開啟 Linux 作為開發環境，或是使用 [Git Bash](https://gitforwindows.org/)，然後你可能會遇到比其他人更多問題
- 一個公有雲帳號（免費或付費）
- 其他 terminal bash 工具: Terraform, Git, jq...

# Terraform

請[下載安裝 Terraform: Official guide](https://www.terraform.io/downloads.html)，你可以依照自己的作業系統下載。本課程會以 Mac OS / Linux 操作為例，直接下載 Terraform Binary，並放置在 path 目錄中：

```
OS=darwin
ARCH=amd64
VERSION=1.0.1

wget "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${OS}_${ARCH}.zip"
unzip "terraform_${VERSION}_${OS}_${ARCH}.zip"

sudo mv terraform /usr/local/bin
```

檢查 Terraform 的版本
- 務必使用 1.0.0 以後的版本

```
terraform version

Terraform v1.0.1
on darwin_amd64
```

# Run example on Public Cloud

這堂課是 Terraform + 公有雲的操作 workshop，因此除了安裝 Terraform 等本地 binary 套件以外，還需要取得有效的公有雲帳號，例如：
- Azure account：課程主要的範例會使用 Azure 介紹
- AWS 或 GCP 的用戶可以考慮跟著課程試用 Azure，拓展技能
- 繼續使用 AWS / GCP 來練習也可以，課程範例會視進度陸續補齊兩大雲的範例。學生仍然可以自行上網搜尋對應的範例來練習
- 使用其他雲（ex. 阿里雲，騰訊雲...）的朋友，課程短期不會支援三大公有雲以外的範例，可以依照課程講解內容先瞭解基本觀念，再自行上網搜尋對應範例。

底下會先說明公有雲的注意事項，以及如何取得並設定公有雲帳號

# Pricing

雲端架構師的核心能力之一，是控制公有雲服務花費。本課程使用公有雲資源，過程中可能會產生費用，在此特別說明。

課程沒有任何費用，然而公有雲是需要收費的，或是使用免費的產品。如果只是為了學習與熟悉，而不是建構生產環境，本課程建議學生可以參考公有雲提供的 Free Trial & Free Plan。正確操作課程的範例，費用都會落在免費的範圍中。

公有雲為推廣各家產品，都有提供免費產品，例如：

- Free plan / Free tier (永遠免費 / 12 月免費)
  - [Azure 的 Free Account 細節](https://azure.microsoft.com/zh-tw/free/free-account-faq?WT.mc_id=AZ-MVP-5003985)
  - [AWS Free 產品細節 (12 個月)](https://aws.amazon.com/tw/free/)
  - [GCP Free Tier 用量限制](https://cloud.google.com/free/docs/gcp-free-tier#free-tier-usage-limits)
  - 如果你有學生身份，請搜尋各服務的 Student free plan
- Free Trial Credit
  - [Azure 提供 30 天內 $200 的 Azure 點數](https://azure.microsoft.com/zh-tw/free?WT.mc_id=AZ-MVP-5003985)
  - [GCP 提供 90 天內價值 $300 美元的抵免額](https://cloud.google.com/free/docs/gcp-free-tier/#free-trial)
  - AWS 沒有提供額度，免費產品已經涵蓋非常廣泛，直接試用即可。（請多參加 AWS 台灣社群活動，有機會可以領取 aws credit）

使用免費來練習的朋友
- 請在 12 月內免費期間內，多多試用 Free Account 內容，了解雲服務的特性
- 如果是 gcp 與 azure ，如果有不小心超額使用的部分，會直接使用免費點數，只要注意點數期限即可
- 請養成練習完後清理 terraform destroy 資源的習慣
- 剛接觸公有雲的朋友，也不用擔心會突然收到好幾萬元的帳單
  - 公有雲都有初始 Quota 的限制，沒有進行特別開通的話，能使用的資源是有限的
  - 所有課程練習都使用 Terraform plan 預覽，才 apply 應用，出錯的機率極低
- 一個月後課程結束，則可以關閉免費帳號
- 萬一萬一真的使用超過額度收到帳單，本課程使用的範例費用都非常便宜，約略是個位數美金的價格
- 養成使用公有雲時常查詢用量與帳單的習慣，預算控制與節費也是 infrastructure 管理的重點

使用付費帳號來練習的朋友
- 請養成練習完後清理 terraform destroy 資源的習慣
- 不用擔心會突然收到好幾萬元的帳單
  - 公有雲都有初始 Quota 的限制，沒有進行特別開通的話，能使用的資源是有限的
  - 本課程使用的範例費用都非常便宜，整體約略是個位數美金的價格

了解費用後，以下介紹如何取得 Azure 免費帳號

# Get Started：Azure

- 請至[Azure 免費帳戶](https://azure.microsoft.com/zh-tw/free?WT.mc_id=AZ-MVP-5003985) 中點選開始免費使用
- 會要求使用 microsoft live account 登入，請註冊一個新帳號
- 填入註冊資訊，並使用新帳號登入
- 建立 Azure 免費帳戶
  - 綁定地區，姓名，電話
  - 使用簡訊進行電話認證
  - 勾選我同意客戶合約與隱私權聲明
  - 下一步，稅務資訊，如果有的可以填入
  - 下一步，卡片身份認證。（Azure 不會自動收費，免費點數用盡後，會詢問您是否要繼續。同意才會付費)
    - 請填入信用卡資訊
    - 填入地址與台灣五碼郵遞區號
    - 點選註冊後 Azure 會驗證信用卡
- 完成後，請至[Azure portal](https://azure.microsoft.com/zh-tw/features/azure-portal?WT.mc_id=AZ-MVP-5003985) 登入

# az-cli

本機已經安裝 Terraform ，那 Terraform 要如何使用 azure 來登入？有幾個方法，這邊我們使用 az-cli 來登入，把登入資訊留在本機上 `~/.azure/accessToken.json` 供 Terraform 使用

[請依照自己的作業系統下載 az-cli](https://docs.microsoft.com/zh-tw/cli/azure/install-azure-cli?WT.mc_id=AZ-MVP-5003985)

Mac 使用者可以使用 homebrew

```
brew install azure-cli

az version
```

安裝完成後，請執行登入，會跳轉 web browser，執行登入。成功後會獲得登入資訊

```
az login

You have logged in. Now let us find all the subscriptions to which you have access...
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "12345678-1234-1234-1234-123456789012",
    "id": "12345678-1234-1234-1234-123456789012",
    "isDefault": true,
    "managedByTenants": [],
    "name": "...",
    "state": "Enabled",
    "tenantId": "12345678-1234-1234-1234-123456789012",
    "user": {
      "name": "chechia@chechia.net",
      "type": "user"
    }
  }
]
```

檢查本機的資訊
```
cat ~/.azure/accessTokens.json | jq
```

# 其他 Terminal 常用工具

- Bash
  - Terraform 的操作環境都在 shell 裏運作，建議學生有使用 bash 經驗，沒有也沒關係，請努力跟上
- Git
  - 本課程建議學生有使用 git 經驗，如果沒有也沒關係，請加緊跟上
  - Git 版本不要太就都可以
- [jq: json parse 工具](https://stedolan.github.io/jq/)
  - 本課程的主要輸入與輸出皆為 json 格式，使用 jq
  - 請使用上面的 link 安裝 jq，建議版本為 1.6

```
$ git --version

git version 2.30.1 (Apple Git-130)

$ jq -h

jq - commandline JSON processor [version 1.6]

Usage:	jq [options] <jq filter> [file...]
	jq [options] --args <jq filter> [strings...]
	jq [options] --jsonargs <jq filter> [JSON_TEXTS...]
```

# homework

- 準備上面的提到的設定與工具
- 閱讀上面工具的文件，熟悉一下操作

# References

- [Azure 的 Free Account 細節](https://azure.microsoft.com/zh-tw/free/free-account-faq?WT.mc_id=AZ-MVP-5003985)
- [AWS Free 產品細節 (12 個月)](https://aws.amazon.com/tw/free/)
- [GCP Free Tier 用量限制](https://cloud.google.com/free/docs/gcp-free-tier#free-tier-usage-limits)
- [Azure 免費帳戶](https://azure.microsoft.com/zh-tw/free?WT.mc_id=AZ-MVP-5003985)
- [jq: json parse 工具](https://stedolan.github.io/jq/)
