#!/bin/bash

#定义时间
cur_time(){
	date "+%Y-%m-%d %H:%M:%S"
}
wx(){
#生成告警脚本 发送到企业微信
sh_name=mzt
cat > $sh_name.sh <<-EOF
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
#发送告警脚本，发送成功后清空脚本
sh $sh_name.sh && echo "Send successfully" > $sh_name.sh
}


#定义变量用于判断告警是否已发送，避免重复发送告警，变量文件不存在，创建文件
[ ! -f /$HOME/$0.warning ] && echo "warning=0" > /$HOME/$0.warning
#导入变量
. /$HOME/$0.warning

#获取本机IP 
ip=`ifconfig eth0|awk '/inet /{print$2}'`
#监控端口 并发数告警阀值 获取当前并发数
port=8303
#并发数告警阀值 
max_number=2500
#获取当前并发数
number=`netstat -antp|grep -w "$ip:$port"|grep "ESTABLISHED"|wc -l`

#判断当并发数大于阀值
if [ "$number" -ge "$max_number" ];then
	#判断告警是否发送过
	if [ "$warning" -eq 0 ];then
		#发送企业微信告警
		wx "$(cur_time) $(hostname) $ip 并发连接数:$number 预警阀值:$max_number 请检查!"
		#更新已发送变量
		sed -i 's/warning=0/warning=1/' /$HOME/$0.warning
	fi
elif [ "$number" -lt "$max_number" ];then
	if [ "$warning" -eq 1 ];then
		wx "$(cur_time) $(hostname) $ip 并发连接数:$number 已恢复"
		sed -i 's/warning=1/warning=0/' /$HOME/$0.warning
	fi
fi

