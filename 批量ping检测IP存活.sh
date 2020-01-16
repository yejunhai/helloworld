#!/bin/bash
#批量ping检测IP存活 > ip.txt 

date +"%Y/%m/%d %H:%M.%S" >> $0.log

echo "--`date "+%Y/%m/%d %H:%M:%S"`--Ctrl+C退出--"

[ ! -f /root/ip.txt ] && echo "ip.txt文件不存在" && exit 1

for ip in `cat ip.txt`
do
        ping -W 1 -n -c 1 $ip &>/dev/null
        if [ $? = 0 ];then
                echo "ping $ip Successful"|tee -a $0.log
        else
                echo "ping $ip Fail"|tee -a $0.log
        fi
done
