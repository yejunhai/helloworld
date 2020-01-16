#!/bin/bash
dns=$(grep 172.26.4.193 /etc/resolv.conf|wc -l)
if [ $dns -eq 1 ] ;then
          echo "DNS配置已存在"
else
          echo "nameserver 172.26.4.193" > /etc/resolv.conf
          echo "nameserver 172.26.4.194" >> /etc/resolv.conf
          echo "DNS配置已更新"
fi