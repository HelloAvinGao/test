#!/bin/bash
copyPath="/rsyncBackup"
user="vagrant"
passwd="vagrant"

yum update -y
yum -y install epel-release
yum install net-tools -y
yum install rsync -y
systemctl start rsyncd.service
systemctl enable rsyncd.service
#备份文件的目录
if [ -d $copyPath ];then
  chown -R root:root $copyPath
else
  mkdir $copyPath
  chown -R root:root $copyPath
fi

# 设置selinux
cp /etc/selinux/config /etc/selinux/config.bak
sed -i 's/SELINUX=enforcing/\SELINUX=permissive/' /etc/selinux/config
setenforce 0
getenforce

#配置rsync
echo "# /etc/rsyncd: configuration file for rsync daemon mode" > /etc/rsyncd.conf
echo "# See rsyncd.conf man page for more options." >> /etc/rsyncd.conf
echo "# configuration example:" >> /etc/rsyncd.conf
echo "# uid = nobody" >> /etc/rsyncd.conf
echo "# gid = nobody" >> /etc/rsyncd.conf
echo "# use chroot = yes" >> /etc/rsyncd.conf
echo "# max connections = 4" >> /etc/rsyncd.conf
echo "# pid file = /var/run/rsyncd.pid" >> /etc/rsyncd.conf
echo "# exclude = lost+found/" >> /etc/rsyncd.conf
echo "# transfer logging = yes" >> /etc/rsyncd.conf
echo "# timeout = 900" >> /etc/rsyncd.conf
echo "# ignore nonreadable = yes" >> /etc/rsyncd.conf
echo "# dont compress   = *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2" >> /etc/rsyncd.conf

echo "# [ftp]" >> /etc/rsyncd.conf
echo "#        path = /home/ftp" >> /etc/rsyncd.conf
echo "#        comment = ftp export area" >> /etc/rsyncd.conf
echo "#设置运行rsync 进程的用户" >> /etc/rsyncd.conf
echo "uid=root" >> /etc/rsyncd.conf
echo "#运行进程的组" >> /etc/rsyncd.conf
echo "gid=root" >> /etc/rsyncd.conf
echo "#端口，如888，870等等只要不被占用，防火墙开启就可以，这里需要修改" >> /etc/rsyncd.conf
echo "port=873" >> /etc/rsyncd.conf
echo "#如果"use chroot"指定为true，那么rsync在传输文件以前首先chroot到path参数所指定的目录下。这样做的原因是实现额外的安全防护，但是缺 点是需要以roots权限，并且不能备份指向外部的符号连接所指向的目录文件。默认情况下chroot值为true。" >> /etc/rsyncd.conf
echo "use chroot=yes" >> /etc/rsyncd.conf
echo "#最大连接数" >> /etc/rsyncd.conf
echo "max connections = 5" >> /etc/rsyncd.conf
echo "#CentOS7中yum安装不需指定pid file 否则报错" >> /etc/rsyncd.conf
echo "# pid file=/var/run/rsyncd.pid" >> /etc/rsyncd.conf
echo "lock file=/var/run/rsyncd.lock" >> /etc/rsyncd.conf
echo "#日志文件" >> /etc/rsyncd.conf
echo "log file=/var/log/rsyncd.log" >> /etc/rsyncd.conf
echo "#排除多个不需同步的文件/目录 建一个exclude.list，里面填写要排除的目录（一行一个文件/目录）" >> /etc/rsyncd.conf
echo "exclude from = /etc/exclude.list" >> /etc/rsyncd.conf
echo "#排除单个文件/目录" >> /etc/rsyncd.conf
echo "#exclude = lost+found/" >> /etc/rsyncd.conf
echo "#transfer logging = yes" >> /etc/rsyncd.conf
echo "#超时时间" >> /etc/rsyncd.conf
echo "timeout = 900" >> /etc/rsyncd.conf
echo "#同步时跳过没有权限的目录" >> /etc/rsyncd.conf
echo "ignore nonreadable = yes" >> /etc/rsyncd.conf
echo "#传输时不压缩的文件" >> /etc/rsyncd.conf
echo "dont compress= *.gz *.tgz *.zip *.z *.Z *.rpm *.deb *.bz2" >> /etc/rsyncd.conf
echo " " >> /etc/rsyncd.conf
echo "#规则名称，作为测试用规则，直接用这个算了。" >> /etc/rsyncd.conf
echo "[helloRsync]" >> /etc/rsyncd.conf
echo "#同步的路径 提前创建好" >> /etc/rsyncd.conf
echo "path = $copyPath" >> /etc/rsyncd.conf
echo "#规则描述" >> /etc/rsyncd.conf
echo "comment = 测试规则" >> /etc/rsyncd.conf
echo "#忽略错误" >> /etc/rsyncd.conf
echo "ignore errors" >> /etc/rsyncd.conf
echo "#是否可以pull 设置服务端文件读写权限" >> /etc/rsyncd.conf
echo "read only = no" >> /etc/rsyncd.conf
echo "#是否可以push" >> /etc/rsyncd.conf
echo "write only = no" >> /etc/rsyncd.conf
echo "#不显示服务端资源列表" >> /etc/rsyncd.conf
echo "list = false" >> /etc/rsyncd.conf
echo "#下面配置同步时候的身份，注意该身份是在rsync里面定义的，并非是本机实际用户。等下说说如何在rsync里面定义身份。" >> /etc/rsyncd.conf
echo "#客户端获取文件的身份此用户并不是本机中确实存在的用户" >> /etc/rsyncd.conf
echo "#该选项指定由空格或逗号分隔的用户名列表，只有这些用户才允许连接该模块" >> /etc/rsyncd.conf
echo "auth users = $user,root" >> /etc/rsyncd.conf
echo "#用来认证客户端的秘钥文件 格式 USERNAME:PASSWD 此文件权" >> /etc/rsyncd.conf
echo "#限一定需要改为600，且属主必须与运行rsync的用户一致。" >> /etc/rsyncd.conf
echo "secrets file = /etc/rsync.password" >> /etc/rsyncd.conf
echo "#允许所有主机访问  *代表所有" >> /etc/rsyncd.conf
echo "hosts allow = *" >> /etc/rsyncd.conf

#vi /etc/exclude.list配置不需要备份的文件/目录
echo "connfig/">/etc/exclude.list
echo "config.php">>/etc/exclude.list
chmod 600 /etc/exclude.list
chmod 600 /etc/rsyncd.conf
echo "$user:$passwd" > /etc/rsync.password
chmod 600 /etc/rsync.password
systemctl restart rsyncd.service
