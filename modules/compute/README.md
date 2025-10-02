# compute Module

## Usage

```hcl
module "compute" {
  source = "./modules/compute"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
