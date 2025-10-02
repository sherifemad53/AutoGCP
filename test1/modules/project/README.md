# project Module

## Usage

```hcl
module "project" {
  source = "./modules/project"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
