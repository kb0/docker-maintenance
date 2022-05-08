FROM jobber:latest
MAINTAINER Kirill Bychkov <kb@na.ru>

USER root

ENV RSNAPSHOT_CONFIG="/home/jobberuser/.rsnapshot.conf"
ENV JOBBER_CONFIG="/home/jobberuser/.jobber"
ENV RSNAPSHOT_CRON_CMD="nice -n 10 ionice -c2 -n7 /usr/bin/rsnapshot -c $RSNAPSHOT_CONFIG"
ENV RSNAPSHOT_HOURLY_TIMES=0
ENV RSNAPSHOT_CRON_HOURLY="0 20 * * * *"
ENV RSNAPSHOT_DAILY_TIMES=7
ENV RSNAPSHOT_CRON_DAILY="0 30 1 * * *"
ENV RSNAPSHOT_WEEKLY_TIMES=4
ENV RSNAPSHOT_CRON_WEEKLY="0 40 2 * * 5"
ENV RSNAPSHOT_MONTHLY_TIMES=12
ENV RSNAPSHOT_CRON_MONTHLY="0 50 4 1 * *"
ENV BACKUP_DIRECTORIES="/opt/backup backup"

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/rsnapshot.conf /etc/rsnapshot.conf

RUN set -x \
    && apk add --no-cache --update ca-certificates openssl curl bash p7zip zip unzip rsnapshot \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/* \
    && chmod +x /entrypoint.sh

USER jobberuser

CMD ["/usr/libexec/jobberrunner", "-u", "/var/jobber/1000/cmd.sock", "/home/jobberuser/.jobber"]
ENTRYPOINT ["/entrypoint.sh"]
