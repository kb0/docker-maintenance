#!/bin/bash
set -e

###############################################################################
# rsnapshot configuration                                                     #
###############################################################################
if [ ! -f $RSNAPSHOT_CONFIG ]; then
    cp /etc/rsnapshot.conf $RSNAPSHOT_CONFIG

    echo "lockfile	/var/run/rsnapshot.pid"

    [ "$RSNAPSHOT_HOURLY_TIMES" -gt 0 ] && echo -e retain'\t'hourly'\t'$RSNAPSHOT_HOURLY_TIMES >> $RSNAPSHOT_CONFIG
    [ "$RSNAPSHOT_DAILY_TIMES" -gt 0 ] && echo -e retain'\t'daily'\t'$RSNAPSHOT_DAILY_TIMES >> $RSNAPSHOT_CONFIG
    [ "$RSNAPSHOT_WEEKLY_TIMES" -gt 0 ] && echo -e retain'\t'weekly'\t'$RSNAPSHOT_WEEKLY_TIMES >> $RSNAPSHOT_CONFIG
    [ "$RSNAPSHOT_MONTHLY_TIMES" -gt 0 ] && echo -e retain'\t'monthly'\t'$RSNAPSHOT_MONTHLY_TIMES >> $RSNAPSHOT_CONFIG

    SAVEIFS=$IFS
    IFS=';'
    for dir in $BACKUP_DIRECTORIES
    do
      tab_dir=$(sed -e 's/ [ ]*/\t/g' <<< $dir )
      echo -e backup'\t'$tab_dir >> $RSNAPSHOT_CONFIG
    done
    IFS=$SAVEIFS
fi

###############################################################################
# jobber configuration                                                        #
###############################################################################
cat > ${JOBBER_CONFIG} <<_EOF_
[jobs]
_EOF_

[ "$RSNAPSHOT_HOURLY_TIMES" -gt 0 ] && cat >> ${JOBBER_CONFIG} <<_EOF_
- name: Rsnapshot Hourly
  cmd: ${RSNAPSHOT_CRON_CMD} hourly
  time: '${RSNAPSHOT_CRON_HOURLY}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false

_EOF_

[ "$RSNAPSHOT_DAILY_TIMES" -gt 0 ] && cat >> ${JOBBER_CONFIG} <<_EOF_
- name: Rsnapshot Daily
  cmd: ${RSNAPSHOT_CRON_CMD} daily
  time: '${RSNAPSHOT_CRON_DAILY}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false

_EOF_

[ "$RSNAPSHOT_WEEKLY_TIMES" -gt 0 ] && cat >> ${JOBBER_CONFIG} <<_EOF_
- name: Rsnapshot Weekly
  cmd: ${RSNAPSHOT_CRON_CMD} weekly
  time: '${RSNAPSHOT_CRON_WEEKLY}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false

_EOF_

[ "$RSNAPSHOT_MONTHLY_TIMES" -gt 0 ] && cat >> ${JOBBER_CONFIG} <<_EOF_
- name: Monthly
  cmd: ${RSNAPSHOT_CRON_CMD} monthly
  time: '${RSNAPSHOT_CRON_MONTHLY}'
  onError: Continue
  notifyOnError: false
  notifyOnFailure: false

_EOF_

for (( i = 1; ; i++ ))
do
  VAR_JOB_ON_ERROR="JOB_ON_ERROR$i"
  VAR_JOB_NAME="JOB_NAME$i"
  VAR_JOB_COMMAND="JOB_COMMAND$i"
  VAR_JOB_TIME="JOB_TIME$i"
  VAR_JOB_NOTIFY_ERR="JOB_NOTIFY_ERR$i"
  VAR_JOB_NOTIFY_FAIL="JOB_NOTIFY_FAIL$i"

  if [ ! -n "${!VAR_JOB_NAME}" ]; then
    break
  fi

  it_job_on_error=${!VAR_JOB_ON_ERROR:-"Continue"}
  it_job_name=${!VAR_JOB_NAME}
  it_job_time=${!VAR_JOB_TIME}
  it_job_command=${!VAR_JOB_COMMAND}
  it_job_notify_error=${!VAR_JOB_NOTIFY_ERR:-"false"}
  it_job_notify_failure=${!VAR_JOB_NOTIFY_FAIL:-"false"}

  cat >> ${JOBBER_CONFIG} <<_EOF_
- name: ${it_job_name}
  cmd: ${it_job_command}
  time: '${it_job_time}'
  onError: ${it_job_on_error}
  notifyOnError: ${it_job_notify_error}
  notifyOnFailure: ${it_job_notify_failure}

_EOF_
done

echo "rsnapshot configuration"
echo "-------------------------------------------------------------------------"
cat $RSNAPSHOT_CONFIG
echo "-------------------------------------------------------------------------"
echo ""

echo "jobber configuration"
echo "-------------------------------------------------------------------------"
cat $JOBBER_CONFIG
echo "-------------------------------------------------------------------------"
echo ""

echo "$@"
exec "$@"
