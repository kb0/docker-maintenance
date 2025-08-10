#!/bin/bash

for base in /etc/letsencrypt/live/*/; do
    CERT="${base}cert.pem"
    if [ -f "$CERT" ]; then
        SUBJECT=$(openssl x509 -in "$CERT" -noout -subject 2>/dev/null | sed 's/^subject=CN=//')
        if [ -n "$SUBJECT" ]; then
          cp "$base/chain.pem" "/etc/ipsec.d/cacerts/$SUBJECT.pem"
          cp "$base/fullchain.pem" "/etc/ipsec.d/certs/$SUBJECT.pem"
          cp "$base/privkey.pem" "/etc/ipsec.d/private/$SUBJECT.pem"
        fi
    fi
done

NET_IFACE=$(route 2>/dev/null | grep -m 1 '^default' | grep -o '[^ ]*$')
[ -z "$NET_IFACE" ] && NET_IFACE=$(ip -4 route list 0/0 2>/dev/null | grep -m 1 -Po '(?<=dev )(\S+)')
[ -z "$NET_IFACE" ] && NET_IFACE=eth0

iptables -A INPUT -p udp --dport 500 --j ACCEPT
iptables -A INPUT -p udp --dport 4500 --j ACCEPT
iptables -A INPUT -p esp -j ACCEPT

IFS=',' read -ra subnets <<< "$VPN_SUBNETS"
for SUBNET in "${subnets[@]}"; do
    echo "add NAT for: $item"
    iptables -t nat -A POSTROUTING -s "$SUBNET/24" -o "$NET_IFACE" -m policy --pol ipsec --dir out -j ACCEPT
    iptables -t nat -A POSTROUTING -s "$SUBNET/24" -o "$NET_IFACE" -j MASQUERADE
done

ipsec start --nofork
