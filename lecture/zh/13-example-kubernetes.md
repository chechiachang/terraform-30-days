# NOTE

- 課程範例會超出永久免費額度，會消耗 azure credit，用完請 destroy
- 範例會產出 kubeconfig 檔案，內含可以存取 cluster control panel 的 private key，請妥善保存
- 範例 AKS 是功能完整的 AKS，但不適合直接做 production 環境使用
  - 需要 補齊 security hardening 

# Prerequisite & Steps

- infrastructure 本身的知識
  - 了解 subnet
  - 了解 AKS
  - 理解 infrastructure 的參數。terraform 的文件並不會說明參數的功能。
- terraform 官方文件，查詢module 的使用方法，參數格式
  - 理解 AKS module 的 inputs, outputs
- 根據需求調整 module 參數
  - 使用 meta-argument, built-in functions 協助管理 module
- plan & apply 完整的 module

# Requirements & spec

今天的範例非常簡單

- 一組 vpn subnets，將 node group 放在 vpn subnet 上
  - `foundation/compute_network` 已經把 vpn subnets 產生出來了
    - 使用 terragrunt dependency 來產生兩個 root module 的依賴
    - 將 network 中的 output 作為 kubernetes cluster 的 input 傳入
- 一個 aks cluster
  - AKS cluster 是代管的 control panel，費用為 $0.1 / hr
    - [Azure Kubernetes Service Pricing](https://azure.microsoft.com/en-us/pricing/details/kubernetes-service/)
  - 一個 default on-demand node group，創建時必須產生
  - (Optional) 一個 on-demand node group
  - (Optional) 一個 spot node group

```
terragrunt init

terragrunt plan

terragrunt apply
```

apply 時間較長
- aks kubernetes control panel 的創建時間約為
- aks node group 的創建時間約為
- 由於 node group depends on control panel，所以無法平行創造，整體花費時間會拉長

# AKS Example

https://docs.microsoft.com/zh-tw/azure/aks/

# Module Issues

- type(any) is bad

# Cleanup

destroy 整座 cluster

# Homework

- 繼續嘗試 `azure/modules/kubernetes_cluster`
  - 新增 spot node group
- 使用 [azurerm AKS module](https://registry.terraform.io/modules/Azure/aks/azurerm/latest) 部署 AKS
  - 閱讀 README.md 以及範例
  - 調整 inputs
  - plan, apply 創建 AKS
  - 比較使用 azurerm 維護的 module，與講者隨手做的 module
- 增加 firewall rule
  - 限制可以存取 master 的 CIDR
