# firewall Module

## Usage

```hcl
module "firewall" {
  source = "./modules/firewall"

  name = "example"
  tags = {
    Environment = "dev"
  }
}
```
