# pki

## Pre-requisites

* [cfssl toolkit](https://github.com/cloudflare/cfssl)
* [yq](https://github.com/mikefarah/yq)

## Directory layout

```sh
📂 pki
├─📄 cfssl-profiles.json   # cfssl certificate profiles used when generating certificates
└─📄 pki.yaml              # Template that gets run through yq to generate cfssl CSRs
```

## cfssl-profiles.json



## pki.yaml

This allows creation of multiple certificates, without repeating a majority of the JSON involved, increasing consistency and reducing room for error.

| Token | Purpose |
|-|-|
| `ORGANIZATION_COUNTRY_CODE`         | Used for the Organization's Country              |
| `ORGANIZATION_STATE_PROVINCE_CODE`  | Used for the Organization's State/Province       |
| `ORGANIZATION_LOCATION`             | Used for the Organization's City/Town            |
| `ORGANIZATION_NAME`                 | Used for the Organization's Legal Name           |
| `ORGANIZATION_ADMINISTRATIVE_EMAIL` | Used for the Organization's Administrative Email |
| `ENVIRONMENT_NAME`                  | Used to help differentiate environments          |
| `INTERMEDIARY_NAME`                 | Used by Intermediate CAs for naming              |
| `CERT_CN`                           | Used where an explicit CN is required            |
| `SERVER_NAME`                       | Used for additional cert SAN                     |
| `SERVER_IP`                         | Used for additional cert SAN                     |

## PKI Build-out

```shell
ORGANIZATION_NAME="Some Company" \
ORGANIZATION_ADMINISTRATIVE_EMAIL="admin@some.tld" \
ORGANIZATION_LOCATION="Centralia" \
ORGANIZATION_STATE_PROVINCE_CODE="Pennsylvania" \
ORGANIZATION_COUNTRY_CODE="US" \
    yq '.[] | explode(.) | (.. | select(tag == "!!str")) |= envsubst' -s '.cn + ".csr"' -o json < pki.yaml
```

## Troubleshooting

### max_path_len

```<add blurb about max_path_len here>```

## References

* https://github.com/cloudflare/cfssl/blob/master/doc/cmd/cfssl.txt
* https://stackoverflow.com/questions/6616470/certificates-basic-constraints-path-length
* https://propellered.com/posts/cfssl_setting_up/
* https://security.stackexchange.com/questions/183681/cfssl-example-certificate-chain-verification-failure
