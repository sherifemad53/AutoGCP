# bucket Module

## Usage

```hcl
module "bucket" {
  source = "./modules/bucket"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
