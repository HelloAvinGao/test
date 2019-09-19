#!/bin/bash
set -x

# SHELL=/bin/bash
# PATH=/sbin:/bin:/usr/sbin:/usr/bin
# MAILTO=root

export list_dir_fmt=json
pwd=${PWD}

indexHtmlPath="$pwd"
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
  serverIP=`cat "$pwd/serverCopy/serverData.json" | jq .ip`
  serverUser=`cat "$pwd/serverCopy/serverData.json" | jq .user`
  serverPassword=`cat "$pwd/serverCopy/serverData.json" | jq .password`
  HttpPort=`cat "$pwd/serverCopy/serverData.json" | jq .port`
  serverConfDataPath="$pwd/serverCopy/serverData.json"
  serverCopyPath=`cat "$pwd/serverCopy/serverData.json" | jq .folder`
  #
  # crontabMinute=`cat "$pwd/serverCopy/serverData.json" | jq .time.minute`
  # crontabHour=`cat "$pwd/serverCopy/serverData.json" | jq .time.hour`
  # crontabDay=`cat "$pwd/serverCopy/serverData.json" | jq .time.day`
  # crontabMonth=`cat "$pwd/serverCopy/serverData.json" | jq .time.month`
  # crontabWeek=`cat "$pwd/serverCopy/serverData.json" | jq .time.week`
  #
  # echo "$crontabMinute $crontabHour $crontabDay $crontabMonth $crontabWeek "

  echo "$serverPassword">/etc/rsync.server.password
  chmod 600 /etc/rsync.server.password
  systemctl restart rsyncd.service

  dates=$(date +%s)
  tar -zcPf $dates.tar.gz $serverCopyPath
  echo "$dates"
  rsync -vzrtopg --progress $dates.tar.gz $serverUser@$serverIP::helloRsync --password-file=/etc/rsync.server.password
  rm -rf "$serverConfDataPath"
  rm -rf *.tar.gz
else
  echo "no json data!!!"
fi
sleep 1
done
