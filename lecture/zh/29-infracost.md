
本篇介紹如何使用 [infracost](https://www.infracost.io/) 工具估計 infrastructure apply 的花費

# infratructure cost management

『給我無限多的預算，我就能撐起全世界』

然而，現實中不存在無限預算的專案，因此成本控管就非常重要。infrastructure 管理中很重要的一部份便是成本控管，以合理成本來架設 infrastructure 是雲端管理必備技能。

為了做到成本控管，我們會需要預估一組 infrastructure 的未來花費，而不是等到 apply 上去後等下個月的帳單來(XD)

這是個教你吃米要知道米價的工具

# Infracost

既然已經導入 terraform，我們完全可以預期一個 root module 會產生多少 infrastructure
- 或是 plan 時候，獲得新 infra 與舊 infra 的差異
- 公有雲的定價 pricing 訊息都是公開的，然而與其去網頁查詢，不如直接整合 public cloud pricing API，更準確
- 整合 infrastructure diff + pricing，透過工具計算整體費用變化就十分容易

# Installation

安裝
- 筆者習慣使用 release binary

```
wget https://github.com/infracost/infracost/releases/download/v0.9.8/infracost-darwin-amd64.tar.gz
tar -zxf infracost-darwin-amd64.tar.gz

sudo mv infracost-darwin-amd64 /usr/local/bin/infracost
```

版本要注意一下，建議用新版
- v0.9.7 之後對於 terragrunt 的支援比較好

```
infracost --version
Infracost v0.9.8

Infracost - cloud cost estimates for Terraform

DOCS
  https://infracost.io/docs

USAGE
  infracost [flags]
  infracost [command]

EXAMPLES
  Generate a cost diff from Terraform directory with any required Terraform flags:

      infracost diff --path /path/to/code --terraform-plan-flags "-var-file=my.tfvars"

  Generate a full cost breakdown from Terraform directory with any required Terraform flags:

      infracost breakdown --path /path/to/code --terraform-plan-flags "-var-file=my.tfvars"

AVAILABLE COMMANDS
  breakdown   Show full breakdown of costs
  completion  Generate completion script
  configure   Display or change global configuration
  diff        Show diff of monthly costs between current and planned state
  help        Help about any command
  output      Combine and output Infracost JSON files in different formats
  register    Register for a free Infracost API key

FLAGS
  -h, --help               help for infracost
      --log-level string   Log level (trace, debug, info, warn, error, fatal)
      --no-color           Turn off colored output
  -v, --version            version for infracost

Use "infracost [command] --help" for more information about a command.
```

# Register

使用 infracost 需要註冊 api key，執行下面命令註冊即可
- credential 會放在 local 路徑

```
infracost register
cat ${HOME}/.config/infracost/credentials.yml
```

# first run

算看看 `azure/_poc/foundation` 要花多少錢

```
infracost diff --path azure/_poc/foundation/

Detected Terraform directory at azure/_poc/foundation/
  ✔ Running terraform plan
  ✔ Running terraform show

✔ Calculating monthly cost estimate

Project: chechiachang/terraform-30-days/azure/_poc/foundation

Monthly cost change for chechiachang/terraform-30-days/azure/_poc/foundation
Amount:  $0.00 ($0.00 -> $0.00)

----------------------------------
Key: ~ changed, + added, - removed

No changes detected. Run infracost breakdown to see the full breakdown.

2 resource types weren't estimated as they're not supported yet, rerun with --show-skipped to see.
Please watch/star https://github.com/infracost/infracost as new resources are added regularly.
```

算出來不用錢？！太佛拉！！
- 打上 `--show-skipped` options 來看到更完整的訊息

```
infracost diff --path azure/_poc/foundation/ --show-skipped

Detected Terraform directory at azure/_poc/foundation/
  ✔ Running terraform plan
  ✔ Running terraform show

✔ Calculating monthly cost estimate

Project: chechiachang/terraform-30-days/azure/_poc/foundation

Monthly cost change for chechiachang/terraform-30-days/azure/_poc/foundation
Amount:  $0.00 ($0.00 -> $0.00)

----------------------------------
Key: ~ changed, + added, - removed

No changes detected. Run infracost breakdown to see the full breakdown.

2 resource types weren't estimated as they're not supported yet.
Please watch/star https://github.com/infracost/infracost as new resources are added regularly.
1 x azurerm_storage_account
1 x azurerm_storage_container
```

兩個 resource 上不支援計價
- 事實上，這兩個 resource 在 azure 上也是不計價的
- 計價的是底下 blob storage 的用量

# With Terragrunt

新版 infracost 會自動偵測 terragrunt 並使用 terragrunt 的設定，產生 .tf 後才會計算 cost，細節請見[infracost官分說明文件](https://www.infracost.io/docs/iac_tools/terragrunt/)
- 注意記得使用 v0.9.7 以後的版本

```
infracost diff --path azure/dev/southeastasia/chechia_net/kubernetes

Detected Terragrunt directory at azure/dev/southeastasia/chechia_net/kubernetes
  ✔ Running terragrunt run-all terragrunt-info
  ✔ Running terragrunt run-all plan
  ✔ Running terragrunt show

✔ Calculating monthly cost estimate

Project: chechiachang/terraform-30-days/azure/dev/southeastasia/chechia_net/kubernetes

+ azurerm_kubernetes_cluster.main
  +$116

    + default_node_pool

        + Instance usage (pay as you go, Standard_D2_v2)
          +$115

        + os_disk

            + Storage (P1)
              +$0.78

    + Load Balancer

        + Data processed
          Monthly cost depends on usage
            +$0.005 per GB

+ azurerm_kubernetes_cluster_node_pool.spot["spot"]
  +$116

    + Instance usage (pay as you go, Standard_D2_v2)
      +$115

    + os_disk

        + Storage (P1)
          +$0.78

Monthly cost change for chechiachang/terraform-30-days/azure/dev/southeastasia/chechia_net/kubernetes
Amount:  +$232 ($0.00 -> $232)

----------------------------------
Key: ~ changed, + added, - removed

To estimate usage-based resources use --usage-file, see https://infracost.io/usage-file
```

# Breakdown

```
infracost breakdown --path azure/dev/southeastasia/chechia_net/kubernetes

Detected Terragrunt directory at azure/dev/southeastasia/chechia_net/kubernetes
  ✔ Running terragrunt run-all terragrunt-info
  ✔ Running terragrunt run-all plan
  ✔ Running terragrunt show

✔ Calculating monthly cost estimate

Project: chechiachang/terraform-30-days/azure/dev/southeastasia/chechia_net/kubernetes

 Name                                                     Monthly Qty  Unit              Monthly Cost

 azurerm_kubernetes_cluster.main
 ├─ default_node_pool
 │  ├─ Instance usage (pay as you go, Standard_D2_v2)             730  hours                  $115.34
 │  └─ os_disk
 │     └─ Storage (P1)                                              1  months                   $0.78
 └─ Load Balancer
    └─ Data processed                                  Monthly cost depends on usage: $0.005 per GB

 azurerm_kubernetes_cluster_node_pool.spot["spot"]
 ├─ Instance usage (pay as you go, Standard_D2_v2)                730  hours                  $115.34
 └─ os_disk
    └─ Storage (P1)                                                 1  months                   $0.78

 OVERALL TOTAL                                                                                $232.24
----------------------------------
To estimate usage-based resources use --usage-file, see https://infracost.io/usage-file
```

這章就這麼單純，但蠻好用的，可以整合到 git-ops workflow 中

