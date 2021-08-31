使用 atlantis 做 terraform automation

terraform 團隊協作的問題
- terraform 是 local apply 的 command tool
  - 每個人都在自己的 local 電腦上 apply terraform
    - 同時改一樣的東西就會 conflicts
  - Iac 的原則是 infrastructureas code，然而各自 apply 卻違反這樣的原則
    - 理想上 master branch 就是最新的 infrastructure，然而因為需要手動 apply，讓 infra 可能停留在前幾個 commit
    - 或是 feature branch 已經 apply 到 infra 上
- IaC 後，需要自動化的 PR Review
  - 最好自動化產生 plan 結果當作 Review 依據
- 最好有自動化的 auto terraform apply
  - 由 CI / CD trigger，依循 git-flow 流程，plan 與 apply infrastructure
  - 透過工具 apply，避免人為 apply 時造成的 human error

# Why not Github Action

如果使用 github.com，完全可以使用 Github Action，來執行 terraform automation，除了本課程內有提供範例外，網路上已經有更多的範例可以參考

然而有些 version control system 是不方便使用 Github Action
- 使用 self-host github enterprise，開啟 Github Action 要耗費大量的算力，目前仍有效能問題
- 使用其他 version control system 例如 gitlab，bitbucket...或是上述 vcs 的 self-hosted enterprise 版本，自然就沒有 Github Action
- 或是團隊不想用 Github Action

這時可以考慮使用公司的 CI / CD 系統，自行寫 terraform 的 pipeline，然後整理前述課程使用到的 command 寫成 shell script 執行。只要是知名的 CI / CD 工具，都能找到許多 terraform 的 pipeline 範例，而這些範例多半是共通的。

如果不希望自己維護 terraform pipeline，現在已經有開源版本的整合工具，幫你做自動化，就是這張要介紹的 [Atlantis: Pull Request Automation](https://www.runatlantis.io/)

# About atlantis

[Atlantis](https://www.runatlantis.io/) 是一款開源免費的自動化 terraform 工具。基本工作流程很單純
- PR 產生的時候， atlantis 自動執行 terraform plan
- Merge 到 master 之後，依據設定，atlantis 執行 terraform apply

Features
- Self-hosted
- 已支援許多 CVS，包含 Github, bitbucket, gitlab, azure-devops, ...

# Local Run atlantis

# Config Atlantis

[Atlantis: terrragrunt support](https://www.runatlantis.io/docs/custom-workflows.html#use-cases)

# Deploy atlantis

terraform generate secret
terraform vm
config.yml

# Alternative: terraform cloud

Terraform Cloud 是 terraform 官方提供的 Terraform automation Saas 服務

需要收費，請見 pricing

雖然目前不是本課程推薦的解決方案，但 terraform cloud 不斷推陳出新許多新功能，未來值得期待。本課程會依據後續參賽進度調整，有機會再分享 terraform cloud 內容。
