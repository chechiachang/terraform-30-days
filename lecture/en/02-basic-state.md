# Let's check terraform.tfstate

# Basic workflow

Detroy -> leave empty state file, with latest applied version

At this stage, we keep things simple
- state is just mapping real world resources
  - In tf file, we name a new resource
    - In state, the metadata (ex. id) is record, so terraform know which recource to track.
  - Some intermediate resources (ex. random)

# State locking

# Sensitive

# Advanced state control will after remote state

# References

https://www.terraform.io/docs/language/state/index.html


---

# Advanced

State manipulate is dangerous

I deleted a database in development environment when introducing Terraform to team. With snaphsot and IaC, our team managed to recover all the infrastructure with miminal data loss. Wonder what could had happened if it was a production DB. 

Don't make the same mistake.

# Import

# Edit state

# why some state operation could be dangerous

state push
state mv

Some reasonable purpose of direct operation on state
- Import existing resources not yet managed by terraform
- Resolve conflicts


# Conclusion

Review state
- mapping real world resources
- ...
