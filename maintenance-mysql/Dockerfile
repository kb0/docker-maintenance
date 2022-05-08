FROM kb00/maintenance:base
MAINTAINER Kirill Bychkov <kb@na.ru>

USER root
RUN set -x \
    && apk add --no-cache --update mysql-client perl perl-doc \
    && curl https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl -o /opt/mysqltuner.pl \
    && chmod +x /opt/mysqltuner.pl \
    && rm -rf /var/cache/apk/*

USER jobberuser
