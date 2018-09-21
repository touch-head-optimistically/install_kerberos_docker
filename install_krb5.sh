#!/bin/bash
yum install -y krb5-server krb5-libs krb5-workstation
#rpm -ivh rpm/libverto-libevent-0.2.5-4.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/libevent-2.0.21-4.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-libs-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/libkadm5-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/words-3.0-22.el7.noarch.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-server-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-workstation-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
	
#拷贝配置文件
yes|cp conf/kadm5.acl.example /var/kerberos/krb5kdc/kadm5.acl
yes|cp conf/kdc.conf.example /var/kerberos/krb5kdc/kdc.conf
yes|cp conf/krb5.conf.example /etc/krb5.conf

#创建kerberos数据库
#默认密码设为admin
kdb5_util create -r YOURPROJECT -s -P admin

#创建KDC admin
#密码123
kadmin.local -r YOURPROJECT -q "addprinc -pw datatom.com root/admin"

#启动服务
systemctl enable krb5kdc
systemctl enable kadmin

systemctl start krb5kdc
systemctl start kadmin

#scp到其他服务器
#保证所有机器的/etc/krb5.conf和当前配置的相同

#新建admin用户
kadmin -r YOURPROJECT -q "addprinc -pw datatom.com testuser" -p root/admin -w datatom.com
