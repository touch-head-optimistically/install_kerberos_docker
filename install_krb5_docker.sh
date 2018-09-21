#!/bin/bash

ps -ef|grep 'kadmind'|awk '{print $2}'|xargs kill -9
ps -ef|grep 'krb5kdc'|awk '{print $2}'|xargs kill -9
rpm -e --nodeps krb5-server-1.15.1-19.el7.x86_64 krb5-workstation-1.15.1-19.el7.x86_64
#rpm -e --nodeps krb5-server-1.15.1-8.el7.x86_64
#rpm -e --nodeps krb5-workstation-1.15.1-8.el7.x86_64
rm -rf /var/kerberos/krb5kdc/
rpm -qa|grep krb5


yum install -y krb5-server krb5-libs krb5-workstation
#rpm -ivh rpm/libverto-libevent-0.2.5-4.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/libevent-2.0.21-4.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-libs-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/libkadm5-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/words-3.0-22.el7.noarch.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-server-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage
#rpm -ivh rpm/krb5-workstation-1.15.1-8.el7.x86_64.rpm --replacefiles --oldpackage

export KRB5CCNAME=FILE:/tmp/tgt
#export KRB5CCNAME=/tmp/ticket

yes|cp conf/kadm5.acl.example /var/kerberos/krb5kdc/kadm5.acl
yes|cp conf/kdc.conf.example /var/kerberos/krb5kdc/kdc.conf
yes|cp conf/krb5.conf.example /etc/krb5.conf


kdb5_util create -r YOURPROJECT -s -P admin


kadmin.local -r YOURPROJECT -q "addprinc -pw datatom.com root/admin"


#systemctl enable krb5kdc
#systemctl enable kadmin

#systemctl start krb5kdc
#systemctl start kadmin
/usr/sbin/krb5kdc
/usr/sbin/kadmind


kadmin -r YOURPROJECT -q "addprinc -pw datatom.com testuser" -p root/admin -w datatom.com
