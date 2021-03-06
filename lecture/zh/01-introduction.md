引言：Terraform 是個好東西。

---

許多年前，我第一次學 Terraform 的時候，

我問主管要不要導入看看 Terraform？

主管說：Go for it!

寫完後，我就直接 apply 下去。於是彈指之間，我就把 staging 的 database 刪掉了。那天下午，測試團隊就直接放假回家。

真實故事。

雖然現在團隊各奔東西，但大家仍常保聯絡，我可以找到人證實這件事。

至於如何彈指之間用 Terraform 刪掉 database 而毫不自覺，大約會在第 15 章左右介紹，敬請期待。

你可能想問：那後來 database 怎麼辦？這不是本文重點，但為了避免大家擔心，說明一下：當時的公有雲資料庫備份已經做得很好，我們成功的從備份 snapshot 復原資料庫。

所以這家公司終究沒有導入 Terraform：誰想導入一進來就把 DB 砍掉的工具？

看到這觀眾可能滿頭問號：『所以你想表達什麼？，叫大家不要用 Terraform 嗎？』

這故事還沒完，請繼續聽下去。

---

幾年之後，我到了一家新公司。一天，團隊的主管跑來找我討論一個困擾，他說：

『公司內部的網路架構與防火牆特別複雜，時常需要去公有雲的 web console 手動修改。
然而你也知道團隊有資深跟資淺的同事，資深的沒問題，就上去點一點解決問題，
但比較菜的上去給我亂點，一天到晚出事我電話接不停』他一臉氣噗噗。

『有沒有什麼好工具可以幫助這些同事？』

我問主管要不要導入看看 Terraform？

主管說：Go for it!

那時我已經很熟了，嘛，至少不會再發生慘劇。

於是後來幾天，我把 Terraform .tf 兜一兜，把已經存在的網路環境跟防火牆拉下來(import)到 Terraform 中，交給團隊使用。

資深工程師本來就很熟 web console，現在連 console 都不用進了，看了說：『屌，我要學』

然後他就學會了。之後他上班滑手機的時間變多了。

在教導其他比較資淺的同事時，為了避免別人發現慘劇，我有特別叮嚀：

如果用 Terraform 的時候，看到螢幕上出現 delete 跟紅色的字，就請雙手離開鍵盤，大聲呼救。

這個原則在團隊剛導入的時候蠻好用的，諸位不妨一試（笑）

總之，資深的把事情搞定了，資淺的跟著有樣學樣，大部分事情也都順利解決了。看起來大家都學得不錯，可喜可賀，我也沒有再繼續推動 Terraform 的事情。

後來我離職要交接的那天，Terraform 的部分畢竟是我導入的，就仔細地做了一下交接：

一個比較資淺的同事就跟我說：『所以這邊就照抄然後按 apply 就好了吧』

李組長（我）眉頭一皺：這個不是用好幾個月，我以為你們很熟了。

但畢竟我要走了，所以我就良心提點一下，啊你這個邊上官網查一下（給 link），這邊來官方文件查一下（給link)

同事就說：『啊怎麼都英文』 他抓抓頭：『我只記得 apply ，跟看到紅字不要點。』

恩，人會一直資淺是有原因的。

這不是在嗆人，畢竟每個人教育背景不同，語言能力不同。Terraform 雖然官方文件整理的不錯，但說實在中文的資源並不多。如果英文能力不好，學起來其實很辛苦。不能怪你。

教了你 Terraform，卻沒有教會你 Terraform，其實也算是我的罪過。阿密陀佛，所以我今天要來還願了。

這系列文章，會把我當初沒教的東西都補齊，並且[連範例一起開源放在 Github https://github.com/chechiachang/terraform-30-days](https://github.com/chechiachang/terraform-30-days) 上，希望當年那位孩子，如果還沒學會 Terraform 的話，來看這篇，然後照我的範例寫個十遍，一甲子功力都傳給你了（笑）

真實故事。

---

又過了幾年，我來到 Maicoin。

我發現裡面的人寫 Terraform 寫的很兇。絕大多數的 infrastructure 都使用 Terraform 管理，許多非公有雲的服務，也都用 Terraform 管理。只差沒用 Terraform 叫達美樂 pizza 而已。恩，這也不是開玩笑，[實際上 Terraform 真的可以定達美樂](https://github.com/ndmckinley/terraform-provider-dominos)。許多的操作與變更，都不在透過 web console 去點擊 UI 更改，而是在 infrastructure as code 裏處理。

我很喜歡同事強的跟鬼一樣。這代表，只要我屁股繼續坐下去，我也會強的跟鬼一樣。

想要一起當同事？[我們有開許多職缺（趁亂徵才ＸＤ）](https://github.com/MaiAmis/Careers)，有意願請私密我聊聊。

這篇用到的許多 Terraform 的想法與觀念，都是來自身邊的同事。感謝 Maicoin 。我學到的經驗也不藏私，都會一一在後面的文章分享。

---

光陰荏苒，歲月如梭，一年一度的鐵人賽又來了。

這是我第三次參賽，之前是佳作（第十二屆），更之前是特優（第十一屆），都是關於 Kubernetes 維運的文章，有興趣的請見

- [Kubernetes 帝王 - Bared Director 團隊](https://ithelp.ithome.com.tw/2020ironman/signup/team/63)之[其實我真的沒想過只是把服務丟上 kubernetes 就有這麼多問題只好來參加30天分享那些年我怎麼在 kubernetes 上踩雷各項服務 ](https://ithelp.ithome.com.tw/users/20120327/ironman/3248)
- [30天太趕留職停薪專心寫文章的靠北戰隊](https://ithelp.ithome.com.tw/2020-12th-ironman/signup/team/130)之[Kubernetes X DevOps X 從零開始導入工具 X 需求分析＊從底層開始研究到懷疑人生的體悟＊](https://ithelp.ithome.com.tw/users/20120327/ironman/3248)

寫了兩年文章，覺得技術工具類的分享，還是工作坊的形式效果最好。然而工作坊的準備也是十分繁雜。認真來說，今年是我最認真的一年，題目內容也是我覺得，最能帶給觀眾實質幫助的一系列。

關於公有雲管理有問題，我一率建議 Terraform。

---

勸世（推坑）文

透過這次機會，除了迴向（？）使用經驗，分享給國內的工程師們外。也給自己一個成長的機會，讓我再次花時間，重新檢視這個每天上班都在使用的工具。

從頭看了一遍官方文件，看了一些官方教學，看了許多社群的 Issue 與討論串，看了一部分 Terraform 在 Github 上的開放原始程式碼。

30 天後，我又變強許多。

我想這才是我的初衷。

還沒報名的觀眾，我強烈建議你也來寫一篇，不為別人只為自己。

立馬報！大不了沒人看，大不了棄賽。寫下去就比人強。真的!

想題目？

- 你打開電腦 terminal ，輸入 history 按下 enter 後，你第一眼看到的字，就是一個非常好的題目。
- 去 browser 看 history ，找出最近有看過的文章，分享，翻譯，補充心得與範例
- 你想像下週上班要做，你覺得最頭痛的工作，是一個很好的題目
- 同上，你今天覺得最簡單的工作，也是一個很好的題目

真的想不到題目的，退一百步，我當你的題目：可以跟著我這篇做範例，然後寫 30 天文章來罵我哪裡寫不好（ＸＤ），請於底下留言，我絕對會每天去拜讀的。

想要發表三十篇文章，只是做或不做的問題而已

---

奧運雜感

運動員要表現好，在國內的環境要能支援。

軟體實力要提升，軟體開發的環境也需要提升。如果國內能更早接收到新的技術，也許台灣也是未來的軟體強國。

雖然 Terrraform 已經發展好多年，不算是新技術（笑)。

拋磚引玉不是口號，很多社群的大大都是這樣披荊斬棘，後人乘涼。這個課程只是跟這些大大的風，希望對產業環境有一些幫助。

扯多了

---

本次鐵人賽是 terraform 實戰 workshop。講白了，技術只看文字是學不會的。希望大家都能有 hands-on 動手做的經驗。課程提供由淺入深的範例，幫助大家學習。

[課程內容與代碼會放在 Github 上: https://github.com/chechiachang/terraform-30-days](https://github.com/chechiachang/terraform-30-days)
[課程內容與代碼會放在 Github 上: https://github.com/chechiachang/terraform-30-days](https://github.com/chechiachang/terraform-30-days)
[課程內容與代碼會放在 Github 上: https://github.com/chechiachang/terraform-30-days](https://github.com/chechiachang/terraform-30-days)

- 所有的課程內容都有 [Azure Cloud](https://docs.microsoft.com/zh-tw?WT.mc_id=AZ-MVP-5003985) 的程式碼範例
- 選擇 Azure （除了因為我是 MVP 外）因為 [Azure 提供的免費方案](https://azure.microsoft.com/zh-tw/free?WT.mc_id=AZ-MVP-5003985) 非常適合沒接觸過的人試用
- AWS 每天上班都在用，下班不想寫 AWS

內容分成三階段
- 課程前段會示範 Terraform 的基本操作與觀念
  - 希望大家能都動手摸過，有一點手感與程式碼語感。稍微體會 Terraform 這個工具
- 課程中期會討論工作流程與文化，包含 gitflow，自動化，團隊協作等
  - 希望大家看過，有個印象，需要時再回來找
- 課程後端會有很多有趣的工具，許多更複雜的鬼東西這邊會跑出來
  - 也是一樣心裡有個底，需要時候去查就好
  - 不過由於還沒寫到，我也不知道會跑出什麼東西

[課程的大綱（預定）在這邊](./00-contents.md)
- 也接受許願想要看的題目，到我完賽前都接受點菜。請於底下留言

課程不會說明公有雲的功能，需要自己做功課
- 會說明實務上的工作流程，例如是如何查找文件資料，寫出好管理的 public cloud resource 等等

---

# Homework

- 依照 [Azure Get-Started Guide](./01-get-started.md) 設定 Azure 帳戶
  - 希望用 GCP 的人可以參考[GCP Get-started Guide](./01-get-started-gcp.md) 但可能就沒有足夠的範例
- 稍微逛一逛 [Terraform 官方文件](https://www.terraform.io/)
- 或是看 Azure 提供的繁體中文 [Terraform on Azure 文件（繁中）](https://docs.microsoft.com/zh-tw/azure/developer/terraform?WT.mc_id=AZ-MVP-5003985)

azure doc 網址後面的 `?WT.mc_id=AZ-MVP-5003985` 是個人 MVP 的追蹤碼，不會記錄使用者行為，討厭的話可以去掉

感謝各位
