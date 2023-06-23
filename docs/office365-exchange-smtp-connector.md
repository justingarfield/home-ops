# Exchange Online SMTP Relay Connector

```cmd
telnet
set localecho
set logfile C:\temp\telnet.log
OPEN jgarfield-com.mail.protection.outlook.com 25
EHLO staging.jgarfield.com
MAIL FROM:<wololo@staging.jgarfield.com>
RCPT TO:<justin@jgarfield.com> NOTIFY=success,failure
DATA
Subject: Testing SMTP Relay

This is a test message
.
QUIT

quit
```
