
本篇是 30 天鐵人賽的最後一篇，本篇做個小節與心得

# 致謝

感謝讀者一路追隨，希望文章內容對獨有有所幫助

感謝公司同事嚴謹的工作態度，我的 Terraform 技術能夠進步都是因為身邊有一群超強同事（Maicoin 持續擴大徵才，意者找請透過粉專私訊我）

感謝鐵人賽參賽團隊的好友，一起互相嗆聲互相砥礪，一起堅持到完賽

感謝我自己，這段時間十分忙碌，仍然抽出時間學習。努力不一定有成過，但絕不會白費

# 公有雲使用上的問題，我一律建議 Terraform

Terraform 除了技術上的改變，還有很大一部分是在解決文化上與工作流程的問題

公有雲上的使用問題，很多都是人為操作性失誤造成的，不論是
- 細節應注意未注意
- 溝通失誤
- 忘記
都是常見的人為錯誤

Terraform 提供一套程式化控制邏輯，限制人為的操作，大幅降低操作性失誤

在擺脫大部分的操作性失誤之後，才有機會為 infrastructure 做快速且大幅度的更新。
- 確實 infra 不改就不會壞，但不改也不會成長進步
- 導入 Terraform 後，infrastructure operation 可以跑得更快，更好，改變卻更精準，像精細手術一樣

再說一次

公有雲使用上的問題，我一律建議 Terraform

# contents index

參賽途中並沒有辦法很好的分類，時間壓力下很難好好的控制文章發表順序。底下根據主題將文章分類，提供讀者查詢

Get started
- Day 01-引言：Terraform 是個好東西
- Day 01-Workshop Azure Get-Started
- Day 01-Workshop Google Cloud Platform Get-Started
- Day 02-是在 Hello？什麼都要 Hello 一下之 Hello Terraform

Basic
- Day 03-Terraform State 之你的 Local State 不是我的 State
- Day 04-Terraform 也有 Backend？啥是 Terraform Backend 能吃嗎？
- Day 05-撰文在疫苗發作時，之module 是 terraform 執行與調用的基本單位
- Day 06-大 module 小 module，能夠重複使用又好維護的就是好 module

Tools
- Day 07-Terraform 寫起來不夠 DRY 的問題，這解 Terragrunt 你試試看
- Day 12-DevOpSec 正夯，沒做 security check 的 module 不要用
- Day 25-reverse terraform: terraformer，從 infrastructure 產生 .tf 內容
- Day 28-給我無限多的預算我就能撐起全世界，infracost 教你吃米知米價

Infrastructure as code: code review
- Day 08-Code 要 Review，Infrastrcture 豈不 Review？吾未見其明也

Infrastructure as code: automation
- Day 09-用 Owner 權限跑 Terraform 等於用 root 權限跑後端，夜路跑多了遲早遇到鬼
- Day 10-自動化是工作標準化與效率的體現，Github Action 做 Terraform 自動化
- Day 11-Atlantis 做 Terraform Remote Plan & Remote Apply

Advanced: terraform syntax
- Day 13-用了十幾天，總算回頭看 Language Syntax 文件
- Day 14-for (i=0; i < 100; i++) createVM(i); infrastructure 也可以 for each 之一
- Day 15-infrastructure 也可以 for each 之二: for each meta-argument
- Day 16-infrastructure 也可以 for each 之三: Count meta-argument
- Day 19-infrastructure 也可以 for each 之四：for & dynamic block

Terraform in production practice
- Day 17-實務上如何寫出 terraform module，以 AKS 為例

State manipulation
- Day 18-更改 state 有其風險，State manipulation 有賺有賠（？），更改前應詳閱官方文件說明書
- Day 20-state inspection-更改 state 有其風險，State manipulation 有賺有賠，更改前應詳閱官方文件說明書之二
- Day 21-state manipulation 之三：我想 rename 怎麼辦？state mv 乾坤大挪移
- Day 22-state manipulation 之四：讓 terraform 遺忘過去的 state rm
- Day 23-state manipulation 之五：terraform import，專案中途導入 terraform 必經之路
- Day 24-請問我可以 taint 你的文章強迫你重寫嗎？state manipulation 之六：terraform taint

Test & Debug
- Day 26-如何測試 terraform 之一：長 code 短 code，能過測試的 code 才是好 code
- Day 27-如何測試 terraform 之二：自動化測試寫起來辛苦，但跑起來就是一個爽
- Day 28-天下無沒有 bug 的 code，如何 debug terraform

# unbfinished content

鐵人賽寫了 30 天文章，然而關於 terraform 還有非常多題目值得細細探討，甚至沒有時間好好讀一下 terraform source code。底下是一些當初列出的題目，現在變成遺珠之憾，提供一些關鍵字與連結，讓有興趣的讀者自己查詢

Terraform 更深入
- [sensistive value 敏感數值的處理，可以看 gruntwork 這這篇文章](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1)
- [trerraform provider 官方文件](https://www.terraform.io/docs/language/providers/index.html)
- [terraform provisioner 官方文件](https://www.terraform.io/docs/language/providers/index.html)
- [如何導入 terraform 可以看光方建議的階段性實踐](https://www.terraform.io/docs/cloud/guides/recommended-practices/part1.html)
- 閱讀 Terraform 原始碼

好用 Tool
- [localstack](https://github.com/localstack/localstack)
- [gruntwork 對使用 terraform-cloud 的文章](https://blog.gruntwork.io/how-deploy-production-grade-infrastructure-using-gruntwork-with-terraform-cl| 70
oud-aca919ca92c2)

Examples
- [maicoin 使用的 k8s terraform: vishwakarma](https://github.com/getamis/vishwakarma)，比較複雜建議熟悉 terraform + k8s 後再來研究

# 未來計畫

未來有時間，會陸續將文章完成，發表在紛絲專頁上

本鐵人賽內容可能會整理成冊出書，已有出版社前來接洽，如果有興趣也請關注粉絲專頁

# End

最後，感謝一路看到最後的各位讀者

軟體工程水很深，大家供勉之
