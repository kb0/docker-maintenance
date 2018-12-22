FROM blacklabelops/jobber:latest
MAINTAINER Kirill Bychkov <kb@na.ru>

RUN set -x \
  && apk add --no-cache --update \
         ca-certificates \
		 openssl \
         mysql-client \
		 perl \
		 perl-doc \
  && update-ca-certificates \
  && wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/mysqltuner.pl -O mysqltuner.pl \
  && rm -rf /var/cache/apk/*