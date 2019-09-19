#!/bin/bash
cd /usr/share/nginx/html/manager
pwd=${PWD}
serverIP=`cat "$pwd/serverCopy/backup.json" | jq .ip | sed 's/\"//g'`
serverUser=`cat "$pwd/serverCopy/backup.json" | jq .user | sed 's/\"//g'`
serverCopyPath=`cat "$pwd/serverCopy/backup.json" | jq .folder | sed 's/\"//g'`

dates=$(date +%s)
tar -zcPf $dates.tar.gz $serverCopyPath
echo "$dates"
rsync -vzrtopg --progress $dates.tar.gz $serverUser@$serverIP::helloRsync --password-file=/etc/rsync.server.password
rm -rf $dates.tar.gz
