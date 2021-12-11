modules directory structure

# Directory design

### Config module depends on infra modules

- parent directory 
  - vault env root -> vault config -> vault infra

ex. azure auth -> azure auth config -> azure infrastructure

- close to reality
- CONS: mixed infra with config in same module

### Config modules loose-coupled with infra modules

- parent directory (composed directory)
  - infra module
  - config module

- modules communicate with modules variable
- PROS: more variables transferation between modules
- CONS: need additional module
