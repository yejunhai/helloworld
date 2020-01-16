#!/bin/bash

for ip in `cat ip.txt`
do
	active=`nmap -Pn -p 3389,22 $ip|grep filtered|wc -l`
	if [ $active -eq 2 ];then
		echo "$ip 3389/22 port filterd"
	else
		echo "$ip 3389/22 open"
	fi
done