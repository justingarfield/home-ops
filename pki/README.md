# pki

## Pre-requisites

This area assumes that you've installed the [cfssl toolkit](https://github.com/cloudflare/cfssl) binaries...

```shell
task tooling:install-cfssl-toolkit
```

## Directory layout

```sh
📂 pki
├─📁 cfssl-templates                         # Tokenized JSON template files used to create cfssl certificates
│ ├─📄 kubernetes-intermediate-ca-csr.json   #
│ ├─📄 root-ca-csr.json                      #
│ ├─📄 root-client-certificate-csr.json      #
│ ├─📄 server-certificate-csr.json           #
│ ├─📄 site-client-certificate-csr.json      #
│ └─📄 site-intermediate-ca-csr.json         #
└─📄 cfssl-profiles.json                     # cfssl certificate profiles used when generating certificates
```

## cfssl-templates folder

The files located under this folder have tokens that will get replaced when running the corresponding tasks associated with them.

This allows creation of multiple certificates, without repeating a majority of the JSON involved, increasing consistency and reducing room for error.

| Token | Purpose | Used In |
|-|-|-|
| `ORGANIZATION_COUNTRY_CODE`         | Used for the Organization's Country              | All templates |
| `ORGANIZATION_STATE_PROVINCE_CODE`  | Used for the Organization's State/Province       | All templates |
| `ORGANIZATION_LOCATION`             | Used for the Organization's City/Town            | All templates |
| `ORGANIZATION_NAME`                 | Used for the Organization's Legal Name           | All templates |
| `ORGANIZATION_ADMINISTRATIVE_EMAIL` | Used for the Organization's Administrative Email | All templates |
| `CERT_CN`                           |  |  |
| `SITE_NAME`                         |  |  |
| `SERVER_NAME`                       |  |  |
| `SERVER_IP`                         |  |  |
| `USER_NAME`                         |  |  |
| `CLUSTER_NAME`                      |  |  |

## PKI Build-out

Assuming you have already filled-in all of the environmental variables in a `.env.whatever` file...

```shell
task pki:generate-ca

OUTPUT_FILENAME=some-intermediary/some-intermediary task pki:generate-and-sign-intermediate-ca
OUTPUT_FILENAME=another-intermediary/another-intermediary task pki:generate-and-sign-intermediate-ca
```

## Troubleshooting

### max_path_len

```<add blurb about max_path_len here>```

## References

* https://stackoverflow.com/questions/6616470/certificates-basic-constraints-path-length
* https://propellered.com/posts/cfssl_setting_up/
* https://security.stackexchange.com/questions/183681/cfssl-example-certificate-chain-verification-failure
