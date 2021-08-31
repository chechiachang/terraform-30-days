
- list / set in hcl
- null resource
- local exec

```
map_helper = { for c in flatten([
    for group, clusters in { for k, v in var.cluster_map : k => v if k != "amp" } : [
      for k, v in clusters.ace : { cluster = k, group = group }
    ]]) : c.cluster => c.group
  }
```

kubeconfig

我覺得，有時寧願不 dry，就是自己 repeat 來避免可讀性變差

就犧牲精簡

畢竟
Hcl 真的不算是很容易處理複雜的型別

他還會有 evaluate 時間先後的問題

執行kubectl最一些噁心操作

local-exec 去跑 provider 尚未支援，但實務上需要的事情
- parse provider config
- 加密 / 解密
