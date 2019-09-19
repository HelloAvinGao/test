#!/bin/bash
# export list_dir_fmt=json
yum install epel-release -y

jq="jq"
mailx="mailx"
sendmail="sendmail"
rsync="rsync"
crontab="crontab"

yum -y install vixie-cron
yum -y install crontabs
systemctl start crond.service
systemctl enable crond.service
systemctl restart crond.service
yum install -y jq
yum install -y rsync xinetd
echo "vagrant">/etc/rsync.server.password
chmod 600 /etc/rsync.server.password
systemctl start rsyncd.service
systemctl enable rsyncd.service
systemctl restart rsyncd.service
