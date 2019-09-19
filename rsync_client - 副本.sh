#!/bin/bash
# set -x

export list_dir_fmt=json
cd /vagrant/Managerhtml
pwd=${PWD}
serverConfDataPath="$pwd/serverCopy/serverData.json"
indexHtmlPath="$pwd"
# HttpPort=`cat "$pwd/serverCopy/serverData.json" | jq .port`
HttpPort=10050
cd $indexHtmlPath
nohup ../web . $HttpPort &
if [ $? -eq 0 ]
then
  echo "http server is already running!"
else
	cd $indexHtmlPath
  # nohup python -m SimpleHTTPServer 10050 &
  nohup ../web . $HttpPort &
fi

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
  systemctl restart rsyncd.service
  mv $serverConfDataPath $pwd/serverCopy/backup.json
else
  echo "no json data!!!"
fi
sleep 1
done
