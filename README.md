## Terraform introduction

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

Version used:
*   Terraform 0.12.8

## Azure authentification
The Azure provider is used to interact with the many resources supported by Azure. The provider needs to be configured with the proper credentials before it can be used.

```
python -m pip install azure-cli
az login
```

## Getting Started

Before terraform apply you must download provider plugin:

```
terraform init
```

Display plan before apply manifest
```
terraform plan
```

Apply manifest
```
terraform apply
```

Destroy stack
```
terraform destroy
```

## Documentation

[https://www.terraform.io/docs/providers/azurerm/index.html](https://www.terraform.io/docs/providers/azurerm/index.html)
