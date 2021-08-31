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

[Atlantis Local Run](https://www.runatlantis.io/guide/testing-locally.html#testing-locally)

Install atlantis
```
wget https://github.com/runatlantis/atlantis/releases/download/v0.17.2/atlantis_darwin_amd64.zip
unzip atlantis_darwin_amd64.zip
sudo mv atlantis /usr/local/bin/atlantis

atlantis -h
```

Install ngrok and run
- 記下 forwarding url ，作為 URL 環境變數
- 保持 ngrok 執行的狀況下，開新 terminal 執行下列步驟
```
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip
unzip ngrok-stable-darwin-amd64.zip
sudo mv ngrok /usr/local/bin/ngrok

./ngrok http 4141

...
Forwarding                    http://41eb-123-194-159-122.ngrok.io -> http://localhost:4141
...
```

Config Github Webhook
- githob repository (ex. chechiachang/terraform-30-days)
- settings -> webhook -> add webhook
- http://41eb-123-194-159-122.ngrok.io/events
- 記下 webhook token，放在安全的地方 -> 作為 SECRET 環境變數

Create Github Personal Access token
- github user -> settings ->  Developer settings -> Personal access tokens
- atlantis
- 只是本地試用，expiration 選 7 天
- 記下 access token，放在安全的地方 -> 作為 TOKEN 環境變數

Local Run atlantis server
- 保持 atlantis server 執行
```
URL="http://41eb-123-194-159-122.ngrok.io"
SECRET="urm-kfp@zab6jua8FWQ"
TOKEN="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"
USERNAME="chechiachang"
REPO_ALLOWLIST="github.com/chechiachang/terraform-30-days"

atlantis server \
--atlantis-url="$URL" \
--gh-user="$USERNAME" \
--gh-token="$TOKEN" \
--gh-webhook-secret="$SECRET" \
--repo-allowlist="$REPO_ALLOWLIST"

...
{"level":"info","ts":"2021-08-31T23:03:31.616+0800","caller":"server/server.go:680","msg":"Atlantis started - listening on port 4141","json":{}}
```

# 


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
