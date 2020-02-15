#!/bin/bash

cur_time(){
	date "+%Y-%m-%d %H:%M:%S"
}
wx(){
#发送到企业微信
sh_name=mzt
cat > $sh_name.sh << EOF
curl '' \
   -H 'Content-Type: application/json' \
   -d '
   {
        "msgtype": "text",
        "text": {
            "content": "$1",
            "mentioned_mobile_list":["$2"]
        }
   }'
EOF
sh $sh_name.sh && rm -rf $sh_name.sh
}



[ ! -f /$HOME/$0.warning ] && echo "warning=0" > /$HOME/$0.warning
. /$HOME/$0.warning

ip=`ifconfig eth0|awk '/inet /{print$2}'`
port=8303
max_number=2500
number=`netstat -antp|grep -w "$ip:$port"|grep "ESTABLISHED"|wc -l`
if [ "$number" -ge "$max_number" ];then
	if [ "$warning" -eq 0 ];then
		wx "$(cur_time) $(hostname) $ip 并发连接数:$number 预警阀值:$max_number 请检查!"
		sed -i 's/warning=0/warning=1/' /$HOME/$0.warning
	fi
elif [ "$number" -lt "$max_number" ];then
	if [ "$warning" -eq 1 ];then
		wx "$(cur_time) $(hostname) $ip 并发连接数:$number 已恢复"
		sed -i 's/warning=1/warning=0/' /$HOME/$0.warning
	fi
fi

