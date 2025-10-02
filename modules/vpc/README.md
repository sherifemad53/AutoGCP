# vpc Module

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
