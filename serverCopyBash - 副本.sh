#!/bin/bash
# export list_dir_fmt=json
yum install epel-release -y

jq="jq"
mailx="mailx"
sendmail="sendmail"
rsync="rsync"
crontab="crontab"

# indexHtmlPath="/vagrant/Managerhtml"


if [ `rpm -qa | grep $crontab |wc -l` -ne 0 ];then
  echo -e "yes,the $crontab package is already installed!"
  systemctl start crond.service
  systemctl enable crond.service
  systemctl restart crond.service
else
  yum -y install vixie-cron
  yum -y install crontabs
  systemctl start crond.service
  systemctl enable crond.service
  systemctl restart crond.service
fi


if [ `rpm -qa | grep $jq |wc -l` -ne 0 ];then
  echo -e "yes,the $jq package is already installed!"
else
  yum install -y jq
fi


# if [ `rpm -qa | grep $sendmail |wc -l` -ne 0 ];then
# echo -e "yes,the $sendmail package is already installed!"
# service sendmail start
# service sendmail enable
# service sendmail restart
# else
# yum install -y sendmail
# service sendmail start
# service sendmail enable
# service sendmail restart
# fi
#
#
# if [ `rpm -qa | grep $mailx |wc -l` -ne 0 ];then
# echo -e "yes,the $mailx package is already installed!"
# else
# yum install -y mailx
# fi


if [ `rpm -qa | grep $rsync |wc -l` -ne 0 ];then
  echo -e "yes,the $rsync package is already installed!"
  echo "vagrant">/etc/rsync.server.password
  chmod 600 /etc/rsync.server.password
  systemctl start rsyncd.service
  systemctl enable rsyncd.service
  systemctl restart rsyncd.service
else
  yum install -y rsync xinetd
  echo "vagrant">/etc/rsync.server.password
  chmod 600 /etc/rsync.server.password
  systemctl start rsyncd.service
  systemctl enable rsyncd.service
  systemctl restart rsyncd.service
fi

# cd $indexHtmlPath
# nohup ../web . 10050 &
# if [ $? -eq 0 ]
# then
#         echo "http server is already running!"
# else
# 	cd $indexHtmlPath
#   # nohup python -m SimpleHTTPServer 10050 &
#   nohup ../web . 10050 &
# fi


# while true
# do
# if [ -f "$serverConfDataPath" ]; then
# rsync -vzrtopg --progress $serverCopyPath $serverUser@$serverIP::helloRsync --password-file=/etc/rsync.server.password
#  # rsync -vzrtopg --progress /vagrant vagrant@192.168.6.112::helloRsync --password-file=/etc/rsync.server.password
# # rm -rf $serverConfDataPath
# else
# echo "Please create json file of the server copy"
# fi
# done
