#!/bin/bash

# Set up user
function setup_conf_and_secret {
    postconf -e "myhostname = $MTP_HOST"
    postconf -e "relayhost = [$MTP_RELAY]:$MTP_PORT"
    postconf -e 'smtp_sasl_auth_enable = yes'
    postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/relay_passwd'
    postconf -e 'smtp_sasl_security_options = noanonymous'
    postconf -e 'smtp_tls_security_level = may'
    postconf -e 'mynetworks = 127.0.0.0/8 172.17.0.0/16'
    postconf -e 'inet_interfaces = all'

    echo "$MTP_RELAY   $MTP_USER:$MTP_PASS" > /etc/postfix/relay_passwd
    postmap /etc/postfix/relay_passwd
}

setup_conf_and_secret

service rsyslog start
service postfix start

touch /var/log/maillog
tail -f /var/log/maillog