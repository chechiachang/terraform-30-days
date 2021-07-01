- [Official guide](https://www.terraform.io/downloads.html)

mac
```
OS=darwin
ARCH=amd64
VERSION=1.0.1

wget "https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${OS}_${ARCH}.zip"
unzip "terraform_${VERSION}_${OS}_${ARCH}.zip"

sudo mv terraform /usr/local/bin
```

```
terraform version

Terraform v1.0.1
on darwin_amd64
```
