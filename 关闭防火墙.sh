#!/bin/bash
release=$(cat /etc/system-release|sed -r 's/.* ([0-9]+)\..*/\1/')
case $release in
       7 )
           systemctl restart sshd 
           systemctl disable firewalld.service 
           systemctl stop firewalld.service
           echo "防火墙已关闭"
       ;;
       6 )
           service iptables stop
           service sshd restart
           chkconfig iptables off
           echo "防火墙已关闭"
       ;;
       * )
           echo "防火墙未关闭"
       ;;
esac