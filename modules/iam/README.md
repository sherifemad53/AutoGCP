# iam Module

## Usage

```hcl
module "iam" {
  source = "./modules/iam"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
