#!/bin/bash
set -x

export list_dir_fmt=json
pwd=${PWD}
serverConfDataPath="$pwd/serverCopy/serverData.json"
indexHtmlPath="$pwd"
HttpPort=`cat "$pwd/serverCopy/serverData.json" | jq .port`

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
  serverPassword=`cat "$pwd/serverCopy/serverData.json" | jq .password`
  crontabMinute=`cat "$pwd/serverCopy/serverData.json" | jq .time.minute`
  crontabHour=`cat "$pwd/serverCopy/serverData.json" | jq .time.hour`
  crontabDay=`cat "$pwd/serverCopy/serverData.json" | jq .time.day`
  crontabMonth=`cat "$pwd/serverCopy/serverData.json" | jq .time.month`
  crontabWeek=`cat "$pwd/serverCopy/serverData.json" | jq .time.week`

  echo "SHELL=/bin/bash" > /etc/crontab
  echo "PATH=/sbin:/bin:/usr/sbin:/usr/bin" >> /etc/crontab
  echo "MAILTO=root" >> /etc/crontab
  echo "$crontabMinute $crontabHour $crontabDay $crontabMonth $crontabWeek sh copy.sh" >> /etc/crontab

  echo "$serverPassword">/etc/rsync.server.password
  chmod 600 /etc/rsync.server.password
  systemctl restart rsyncd.service
  rm -rf $serverConfDataPath
else
  echo "no json data!!!"
fi
sleep 1
done
