# Gitflow

### Many security volibilities during tfsec

Forgive me: 鐵人賽太趕了沒時間修XD，請原諒我`<(_ _)>`

### terraform validate failed with service account login

terraform validate 時因為 provider 設定導致的 validate error。原則上
- `_poc` 內的 root module 使用 user login
- `foundation/terraform_backend` 是設定 service principal 的基礎，使用 user login
- 其他環境 module 使用 service principal login

Solution: try az login as user before run terraform

# Terraform error

### az login as service principal will fail in some poc modules

- `security_group`

Solution: try az login as user before run terraform
