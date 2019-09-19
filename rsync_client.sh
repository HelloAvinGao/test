#!/bin/bash
# set -x
yum update -y
yum -y install epel-release
yum -y install vixie-cron
yum -y install crontabs
systemctl start crond.service
systemctl enable crond.service
systemctl restart crond.service
yum -y install  jq
yum -y install  rsync xinetd
echo "vagrant">/etc/rsync.server.password
chmod 600 /etc/rsync.server.password
systemctl start rsyncd.service
systemctl enable rsyncd.service
systemctl restart rsyncd.service

cd /usr/share/nginx/html/manager
pwd=${PWD}
serverConfDataPath="$pwd/serverCopy/serverData.json"
indexHtmlPath="$pwd"


while true
do
if [ -f "$serverConfDataPath" ]; then
  serverPassword=`cat "$pwd/serverCopy/serverData.json" | jq .password | sed 's/\"//g'`
  crontabMinute=`cat "$pwd/serverCopy/serverData.json" | jq .time.minute | sed 's/\"//g'`
  crontabHour=`cat "$pwd/serverCopy/serverData.json" | jq .time.hour | sed 's/\"//g'`
  crontabDay=`cat "$pwd/serverCopy/serverData.json" | jq .time.day | sed 's/\"//g'`
  crontabMonth=`cat "$pwd/serverCopy/serverData.json" | jq .time.month | sed 's/\"//g'`
  crontabWeek=`cat "$pwd/serverCopy/serverData.json" | jq .time.week | sed 's/\"//g'`

  # echo "SHELL=/bin/bash" > /etc/crontab
  # echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/crontab
  # echo "MAILTO=root" >> /etc/crontab
  echo "$crontabMinute $crontabHour $crontabDay $crontabMonth $crontabWeek $pwd/copy.sh" > /var/spool/cron/root
  # service crond restart
  echo "$serverPassword">/etc/rsync.server.password
  chmod 600 /etc/rsync.server.password
  mv $pwd/serverCopy/serverData.json $pwd/serverCopy/backup.json
  cat $pwd/serverCopy/backup.json
else
  echo "no json data!!!"
fi
sleep 1
done
