# pki

## Pre-requisites

This area assumes that you've installed the cfssl-toolkit binaries...

```shell
task tooling:install-cfssl-toolkit
```

## Tokenized Files

The files located under this folder have tokens that will get replaced when running the corresponding tasks associated with them.

This allows me to share as-much of my workflow with you as possible, but not expose what my actual Site Names, DNS, OU, etc. actually are.

### Replaceable Tokens Provided

|  |||
|-|-|-|
| `CERT_COUNTRY` |  |  |
| `CERT_STATE` |  |  |
| `CERT_LOCATION` |  |  |
| `ORGANIZATION_NAME` |  |  |
| `SITE_NAME` |  |  |
| `CERT_DOMAIN` |  |  |

## References

https://stackoverflow.com/questions/6616470/certificates-basic-constraints-path-length
https://propellered.com/posts/cfssl_setting_up/
https://security.stackexchange.com/questions/183681/cfssl-example-certificate-chain-verification-failure
