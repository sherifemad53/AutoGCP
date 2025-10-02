# nat Module

## Usage

```hcl
module "nat" {
  source = "./modules/nat"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
