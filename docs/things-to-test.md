#

Checklist of things to test and have plans for...

* Power Outage
* Bad HDD
* Full CP Node outage
  * Currently have backup cold-spare at-ready
*


## Double-check these Authelia Settings for Production

```yaml
env:
  AUTHELIA_THEME: "dark"
  AUTHELIA_DEFAULT_REDIRECTION_URL: "https://auth.${PUBLIC_DOMAIN}"
  AUTHELIA_DEFAULT_2FA_METHOD: "totp"
  AUTHELIA_LOG_LEVEL: "info"
  AUTHELIA_TOTP_ISSUER: "${PUBLIC_DOMAIN}"
  AUTHELIA_WEBAUTHN_DISABLE: "true"
  AUTHELIA_NTP_ADDRESS: "${NTP_SERVER_IP}"
  AUTHELIA_DUO_API_DISABLE: "true"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_URL: "ldap://lldap.lldap.svc.cluster.local:389"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_USERNAME_ATTRIBUTE: "uid"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_ADDITIONAL_USERS_DN: "ou=people"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_USERS_FILTER: "(&({username_attribute}={input})(objectClass=person))"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_ADDITIONAL_GROUPS_DN: "ou=groups"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_GROUPS_FILTER: "(member={dn})"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_GROUP_NAME_ATTRIBUTE: "cn"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_MAIL_ATTRIBUTE: "mail"
  AUTHELIA_AUTHENTICATION_BACKEND_LDAP_DISPLAY_NAME_ATTRIBUTE: "displayName"
  AUTHELIA_SESSION_DOMAIN: "${PUBLIC_DOMAIN}"
  AUTHELIA_STORAGE_LOCAL_PATH: "/config/db.sqlite3"
  AUTHELIA_PASSWORD_POLICY_ZXCVBN_ENABLED: "true"
  AUTHELIA_NOTIFIER_SMTP_PORT: "587"
  AUTHELIA_NOTIFIER_SMTP_SENDER: "Authelia <authelia@${PUBLIC_DOMAIN}>"

networks:
  - name: internal
    networks: ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
```

```yaml
AUTHELIA_CERTIFICATES_DIRECTORY:
AUTHELIA_LOG_KEEP_STDOUT:
AUTHELIA_IDENTITY_PROVIDERS_OIDC_ENABLE_CLIENT_DEBUG_MESSAGES:
AUTHELIA_IDENTITY_PROVIDERS_OIDC_CORS_ALLOWED_ORIGINS_FROM_CLIENT_REDIRECT_URIS:
AUTHELIA_AUTHENTICATION_BACKEND_PASSWORD_RESET_CUSTOM_URL:
AUTHELIA_AUTHENTICATION_BACKEND_REFRESH_INTERVAL: 1m
AUTHELIA_AUTHENTICATION_BACKEND_LDAP_START_TLS: "true"
AUTHELIA_AUTHENTICATION_BACKEND_LDAP_TLS_SERVER_NAME:
AUTHELIA_SESSION_SAME_SITE: strict
AUTHELIA_SESSION_REDIS_HOST: redis.database.svc.cluster.local
AUTHELIA_SESSION_REDIS_DATABASE_INDEX: 14
AUTHELIA_DUO_API_DISABLE: "false"
AUTHELIA_NTP_VERSION:
AUTHELIA_NTP_MAX_DESYNC:
AUTHELIA_SERVER_TLS_CERTIFICATE:
AUTHELIA_SERVER_HEADERS_CSP_TEMPLATE:
AUTHELIA_TELEMETRY_METRICS_ENABLED: "true"
AUTHELIA_TELEMETRY_METRICS_ADDRESS: tcp://0.0.0.0:8080
# AUTHELIA_WEBAUTHN_DISABLE: "false"
AUTHELIA_WEBAUTHN_DISPLAY_NAME: ${PUBLIC_DOMAIN}
AUTHELIA_WEBAUTHN_ATTESTATION_CONVEYANCE_PREFERENCE:
AUTHELIA_WEBAUTHN_USER_VERIFICATION:
AUTHELIA_WEBAUTHN_TIMEOUT:
```

```yaml
    service:
      main:
        ports:
          http:
            port: *port
          metrics:
            enabled: true
            port: 8080
    serviceMonitor:
      main:
        enabled: true
        endpoints:
          - port: metrics
            scheme: http
            path: /metrics
            interval: 1m
            scrapeTimeout: 10s
    probes:
      liveness: &probes
        enabled: true
        custom: true
        spec:
          httpGet:
            path: /api/health
            port: *port
          initialDelaySeconds: 0
          periodSeconds: 10
          timeoutSeconds: 1
          failureThreshold: 3
      readiness: *probes
      startup:
        enabled: false
    ingress:
      main:
        enabled: true
        ingressClassName: cilium
        annotations:
          hajimari.io/icon: mdi:shield-account
          cert-manager.io/cluster-issuer: letsencrypt
        hosts:
          - host: &host "auth.${PUBLIC_DNS_ZONE}"
            paths:
              - path: /
                pathType: Prefix
        tls:
          - hosts:
              - *host
            secretName: tls-authelia
    persistence:
      config:
        enabled: true
        type: configMap
        name: authelia-configmap
        subPath: configuration.yml
        mountPath: /config/configuration.yml
        readOnly: false
```
