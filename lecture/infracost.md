Infracost
===

```
wget https://github.com/infracost/infracost/releases/download/v0.9.2/infracost-darwin-amd64.tar.gz
tar -zxf infracost-darwin-amd64.tar.gz

sudo mv infracost-darwin-amd64 /usr/local/bin/infracost

infracost --version
Infracost v0.9.2

# Clean up
rm infracost-darwin-amd64.tar.gz
```

# Register

```
infracost register
cat ${HOME}/.config/infracost/credentials.yml
```

# Breakdown

```
infracost breakdown --path azure/foundation

Detected Terraform directory at azure/foundation
  ✔ Running terraform plan
  ✔ Running terraform show

✔ Calculating monthly cost estimate

Project: chechiachang/terraform-30-days/azure/foundation

 Name  Monthly Qty  Unit  Monthly Cost

 OVERALL TOTAL                   $0.00
```
