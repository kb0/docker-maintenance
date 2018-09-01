FROM blacklabelops/jobber:latest
MAINTAINER Kirill Bychkov <kb@na.ru>

RUN set -x \
  && apk add --no-cache --update mysql-client \
  && rm -rf /var/cache/apk/*