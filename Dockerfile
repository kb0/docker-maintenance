FROM alpine:3.8
MAINTAINER Kirill Bychkov <kb@na.ru>

ENV JOB "* * * * *  date"

RUN set -x \
  && apk add --no-cache --update dcron mysql-client \
  && rm -rf /var/cache/apk/*

RUN echo $JOB > /var/spool/cron/crontabs/root
  
# Define default command.
CMD [ "crond", "-L", "/dev/stdout", "-f"]