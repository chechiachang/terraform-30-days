本章介紹 terraform 的 `for_each`，以及如何運用 meta-argument 管理 resource

# for Expression

For expression 是 terraform configuration language (hcl) 內的 syntax 語法
for each meta-argument 是
- `for_each` 是在計算 resource block {} 的 meta 時使用
- for expression 是在處理 values 的運算

https://www.terraform.io/docs/language/expressions/for.html

```
poolNameTuple = { for p in var.node_pools : name => p.name }

poolNameList = [ 
  for p in var.node_pools : "p.name"
]

output "pool_name_list" {
  value = [for p in var.node_pools : p.name]
}
```

兩個語法的定義位階不同
- 一個是 terraform 的功能
- 一個是 hcl 就定義的語法

# for expression as for each argument

```
for_each = [for p in var.node_pools : p.name]
```

for 產出的是 list

```
for_each = [
  var.node_pools["spot"].name
  var.node_pools["on-demand"].name
  ...
]
```

一樣需要考量 for each 的限制
- for expression evaluation 需要是決定性的，不能有 conditional expression

# Homework: for examples

請依照[Terraform 官方文件 for example](https://www.terraform.io/docs/language/expressions/for.html)，嘗試每個 example，以熟悉 for syntax 使用

# Dynamic block

想要管理很多類似的多個 resource block，我們可以參考使用 meta-argument，來管理 resource block

有個時候，一個 resource block 中，會有 repeatable nested blocks arguments，例如
- [ azurerm virtual machine 中](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine#storage_data_disk)，可以定義多個 `storage_data_disk`

```
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name          = "data1"
    caching       = "None"
    create_option = "Attach"
    disk_size_gb  = "100"
  }

  storage_data_disk {
    name          = "data2"
    caching       = "None"
    create_option = "Attach"
    disk_size_gb  = "200"
  }

  storage_data_disk {
    name          = "data3"
    caching       = "None"
    create_option = "Attach"
    disk_size_gb  = "300"
  }
  ...
}
```

這時候，是想要管理一個 block 中的 field block，讓他一據 input 動態產生，這時可以使用 [Dynamic block](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)

以上面這個例子，可以改寫成 dynamic blocks

```
locals {
  storage_data_disks = [
    {
      name          = "data1"
      disk_size_gb  = "100"
    },
    {
      name          = "data2"
      disk_size_gb  = "200"
    },
    {
      name          = "data3"
      disk_size_gb  = "300"
    }
  ]
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  dynamic "storage_data_disk" {
    for_each = var.storage_data_disks
    content {
      name              = storage_data_disk.value["name"]
      caching           = "None"
      create_option     = "Attach"
      disk_size_gb      = storage_data_disk.value["disk_size_gb"]
    }
  }
  ...
}
```

# Multi-level nested dynamic block

許多高階程式語言有提供 nested loop，terraform dynamic block 也提供 nested
- 這邊範例使用的 variable 是 map of object
- object 中的 origins field type 是 set of object

```
variable "load_balancer_origin_groups" {
  type = map(object({
    origins = set(object({
      hostname = string
    }))
  }))
}

resource "load_balancer" "main" {

  dynamic "origin_group" {
    for_each = var.load_balancer_origin_groups
    content {
      name = origin_group.key

      dynamic "origin" {
        for_each = origin_group.value.origins
        content {
          hostname = origin.value.hostname
        }
      }
    }
  }

}
```

這個範例，在複雜的網路設定相關的 resource 很有機會看到。double nested dynamic block 的問題
- 可讀性已經非常差了
- debug 的時候更痛苦
- 由於是 dynamic block，需要 evaluation 的時候才會展開這些 block
- 需要善用 console debug，才知道展開到底長什麼樣子

通常比較好的 provider （例如三大公有雲）會提供另外的 resource block 來管理這些 nested block
- 可以寫 `load_balancer` resource
- 加上 `origin_group` resource
- 後使用 attachment，把兩個 resource 關聯起來

# Note

- for expression 是 hcl syntax，意思是只要以 hcl 為底層的 configutation language 都可以使用（ex. tcl，vault config，consul config，...）
- for each meta-argument 是 terraform 的 resource block argument，terraform 中才可以使用，並且用來操作 resource block
- dynamic block 是 terraform 的 in-resource argument，可以視作 resource block {} 中的一個特別的參數，用來動態產生 repeatable nested block

# Source code

熟 golang 的不妨看一下 source code

- [For each evaluation](https://github.com/hashicorp/terraform/blob/c687ebeaf19c7c89188727ffc54b03bcc6e51a01/internal/terraform/eval_for_each.go)
  - for each evaluation 的流程
  - iterate set 的流程

---

# Count

要管理重複的 resource block ，Terrafrom 還提供另一個 meta-argument count。範例
- 建立一組 `azurerm_virtual_machine`
- 使用 count meta-argument，告訴 terraform 這組 resource block 要有三個
- 希望 vm.name 是 unique 方便辨識，所以使用 ${count.index} 取得每個 count 產生的 resource 的 index

```
resource "azurerm_virtual_machine" "main" {
  count                 = 3

  name                  = "${var.prefix}-vm-${count.index}"
  ...
}
```

實際 output 會類似
- 產生一組 recource block
- state 路徑在 `azurerm_virtual_machine.main`，這邊會是一組 collection，可以使用 index 存取
- `azurerm_virtual_machine.main[0]`
- `azurerm_virtual_machine.main[1]`
- `azurerm_virtual_machine.main[2]`

```
resource "azurerm_virtual_machine" "main[0]" {
  name                  = "${var.prefix}-vm-0"
  ...
}

resource "azurerm_virtual_machine" "main[1]" {
  name                  = "${var.prefix}-vm-1"
  ...
}

resource "azurerm_virtual_machine" "main[2]" {
  name                  = "${var.prefix}-vm-2"
  ...
}
```

Count 與 for each 是互斥的，意思是 resource block 中只能使用其中一個 meta-argument，一起使用的話會在 validate 出 syntax error

# Count index Issue

for each 使用 input variable 的 key 作為 key，count 使用則搭配 count.index，在 collection 取得參數值

首先是 node pool 範例，使用 for each meta-argument

```
# modules/kubernetes_cluster/node_pool.tf

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each              = var.node_pools
  name                  = each.value.name
  ...
}
```

- 我們可以更改 for each，改用 count meta-argument 來描述
- 使用 length() function 取得 map of object 的 member 數量，作為 count 參數
- each 也改用 count.index 來存取 `var.node_pools`

```
# modules/kubernetes_cluster/node_pool.tf

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  count             = length(var.node_pools)
  name              = var.node_pools[count.index].name
  ...
}
```

展開變成

```
# modules/kubernetes_cluster/node_pool.tf

resource "azurerm_kubernetes_cluster_node_pool" "main[0]" {
  name              = var.node_pools[0].name
  ...
}

resource "azurerm_kubernetes_cluster_node_pool" "main[1]" {
  name              = var.node_pools[1].name
  ...
}
```

注意：上面使用 count 與 for each 的取值方式不同，這裡會可能造成 count.index 的錯亂
- terraform 的 map 是 unordered map，本身沒有 index
- 使用 for each 時，map 是 order 是因為依照 key 的 alphabatical order，依據
- 使用 count.index 時，不保證 index 與 key 的順序相同
- 如果上層 `var.node_pools` 有改變， plan 的時候重新計算 resource block，便有可能導致順序錯亂
- 加上由於這個例子中的 resource 沒有依賴性，是平行化產生的，本身不保證先後順序，可能會產生問題。

Terraform 官方在 [When to use count and for each](https://www.terraform.io/docs/language/meta-arguments/count.html#when-to-use-for_each-instead-of-count) 說明 count 與 for each 建議的使用時機，已經不建議如此使用 count 了

那為何 count 還是會存在？是歷史緣故 resource 中的 count 支援版本很早，for each 要到 0.12 之後的 terraform 版本才支援。也就是說，古人沒有 for each 可以用被迫使用 count + count.index
- 事實上，如果使用 terraform 久了，還是有機會在比較舊的 module 立面看到 count 的大量使用

# Count vs for each

Terraform 官方在 [When to use count and for each](https://www.terraform.io/docs/language/meta-arguments/count.html#when-to-use-for_each-instead-of-count) 說明 count 與 for each 建議的使用時機

- 如果產生一組全部都相同的 resource block，可以使用 count
- 如果內部有變數處理，或是取用 input argument 的值，使用 for each 會比較安全

能用 for each 的時候就用 for each
- for each 能夠使用 map
- 使用 collection

# Source code

熟 golang 的不妨看一下 source code

- [count evaluation](https://github.com/hashicorp/terraform/blob/c687ebeaf19c7c89188727ffc54b03bcc6e51a01/internal/terraform/eval_count.go)
  - 以及 sensitive input 的處理
