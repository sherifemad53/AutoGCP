# sql Module

## Usage

```hcl
module "sql" {
  source = "./modules/sql"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
