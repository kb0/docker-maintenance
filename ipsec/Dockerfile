FROM alpine:3.22

ENV VPN_SUBNETS "172.20.0.0"

RUN set -x \
    && echo "https://mirror.yandex.ru/mirrors/alpine/v3.22/main" > /etc/apk/repositories \
    && echo "https://mirror.yandex.ru/mirrors/alpine/v3.22/community" >> /etc/apk/repositories \
    && apk add --no-cache bash bind-tools coreutils openssl iptables libreswan

COPY etc/sysctl.d/99-ipsec.conf /etc/sysctl.d/99-ipsec.conf

COPY etc/ipsec.d/* /etc/ipsec.d/
RUN echo "include /etc/ipsec.d/*.conf" > /etc/ipsec.conf

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose IPsec ports
EXPOSE 500/udp 4500/udp

CMD ["/entrypoint.sh"]