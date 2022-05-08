FROM kb00/maintenance:base
MAINTAINER Kirill Bychkov <kb@na.ru>

USER root
RUN set -x \
    && apk add --no-cache --update postgresql-client perl perl-doc \
    && curl https://raw.githubusercontent.com/jfcoz/postgresqltuner/master/postgresqltuner.pl -o /opt/postgresqltuner.pl \
    && chmod +x /opt/postgresqltuner.pl \
    && rm -rf /var/cache/apk/*

USER jobberuser
