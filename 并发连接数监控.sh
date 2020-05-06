#!/bin/bash
#巡检并发连接数 发送企业微信告警
#yejunhai 
#2020-2-25 

#定义时间
cur_time(){
	date "+%Y-%m-%d %H:%M:%S"
}
wx(){
#生成告警脚本 发送到企业微信
sh_name=$0
cat > $sh_name.json <<-EOF
curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=d25d7339-9b15-4b17-80ae-2f546140c349' \
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
sh $sh_name.json && echo "Send successfully" > $sh_name.json
}
:<<EOF

#定义变量用于判断告警是否已发送，避免重复发送告警，变量文件不存在，创建文件
[ ! -f $0.warning ] && echo "warning=0" > $0.warning
#导入变量
. $0.warning

#获取本机IP 
ip=`ifconfig eth0|awk '/inet /{print$2}'`
#监控端口 并发数告警阀值 获取当前并发数
port=$1
#并发数告警阀值 
max_number=1000
#获取当前并发数
number=`netstat -ant|grep -w "$ip:$port"|grep "ESTABLISHED"|wc -l`
#判断当并发数大于阀值
if [ "$number" -ge "$max_number" ];then
	#判断告警是否发送过
	if [ "$warning" -eq 0 ];then
		#发送企业微信告警
		wx "$(cur_time) $(hostname) $ip:$port 并发连接数:$number 预警阀值:$max_number 请检查!"
		#更新已发送变量
		sed -i 's/warning=0/warning=1/' $0.warning
	else
		echo "$(cur_time) $(hostname) $ip:$port 并发连接数:$number" |tee -a $0.log
	fi
elif [ "$number" -lt "$max_number" ];then
	if [ "$warning" -eq 1 ];then
		wx "$(cur_time) $(hostname) $ip:$port 并发连接数:$number 已恢复"
		sed -i 's/warning=1/warning=0/' $0.warning 
	else
		echo "$(cur_time) $(hostname) $ip:$port 并发连接数:$number" |tee -a $0.log
	fi
fi
EOF
# ORACLE_BASE=/u01/app/oracle; export ORACLE_BASE
# ORACLE_HOME=$ORACLE_BASE/product/12.1.0/client_1; export ORACLE_HOME
# PATH=.:${JAVA_HOME}/bin:${PATH}:$HOME/bin:$ORACLE_HOME/bin
# export PATH

# declare -A instances
# instances=([192.168.64.51]="mztdfp" [192.168.64.52]="mztdfp" [192.168.56.195]="mztorcl" [192.168.56.196]="mztorcl")
# for db_ip in $(echo ${!instances[*]})
# do
#         status=`tnsping $db_ip:1521/${instances[$ip]}|grep "OK"|wc -l`
#         if [ "$status" -eq 0 ];then
#         	if [ "$warning" -eq 0 ];then
#         		wx "$(cur_time) $(hostname) $ip $db_ip:1521/${instances[$ip]} 数据库连接异常，请检查!"
#         		sed -i 's/warning=0/warning=1/' $0.warning
#         		break
# 		else
# 			echo "$(cur_time) $(hostname) $ip $db_ip:1521/${instances[$ip]} 数据库连接异常，请检查!" |tee -a $0.log #写日志
# 			break
# 		fi
#         elif [ "$status" -eq 1 ];then
# 		if [ "$warning" -eq 1 ];then
# 			wx "$(cur_time) $(hostname) $ip $db_ip:1521/${instances[$ip]} 数据库连接已恢复"
# 			sed -i 's/warning=1/warning=0/' $0.warning 
# 		else
# 			echo "$(cur_time) $(hostname) $ip $db_ip:1521/${instances[$ip]} Successfully" |tee -a $0.log
# 		fi
#         fi
# done

cpu=$(vmstat|awk 'NR==3{printf("%d",(100-$15))}')
mem=$(free|awk '/Mem:/{printf("%d",($2-$4)/$2*100)}')
if [ "$cpu" -ge 80 -o "$mem" -ge 10 ];then
	if [ "$warning" -eq 0 ];then
		wx "$(cur_time) \n$(hostname) $ip \nCPU利用率: $cpu% \n内存利用率: $mem% \n请检查！！！"
		sed -i 's/warning=0/warning=1/' $0.warning
	fi
elif [ "$warning" -eq 1 ];then
	wx "$(cur_time) \n$(hostname) $ip \nCPU利用率: $cpu% \n内存利用率: $mem% \n已恢复"
	sed -i 's/warning=1/warning=0/' $0.warning 
else
	echo "$(cur_time) \n$(hostname) $ip \nCPU利用率: $cpu% \n内存利用率: $mem% \n" |tee -a $0.log	   
fi

process=tomcat
process_status=`ps -aux|grep "$process"|grep -v "grep"|wc -l`
if [ "$process_status" -eq 0 ];then
	if [ "$warning" -eq 0 ];then
		tomcat_process="Disabled"
        wx "$(cur_time) \n$(hostname) $ip\ntomcat进程：$tomcat_process \n请检查！！！"
		sed -i 's/warning=0/warning=1/' $0.warning
	else
		tomcat_process="Disabled"
		echo "$(cur_time) \n$(hostname) $ip\ntomcat进程：$tomcat_process" |tee -a $0.log
	fi
elif [ "$process_status" -gt 0 ];then
	if [ "$warning" -eq 1 ];then
		tomcat_process="Enable"
		wx "$(cur_time) \n$(hostname) $ip\ntomcat进程：$tomcat_process \n已恢复"
		sed -i 's/warning=1/warning=0/' $0.warning
	fi
else
	tomcat_process="Enable"
	echo "$(cur_time) \n$(hostname) $ip\ntomcat进程：$tomcat_process" |tee -a $0.log
fi


for disk_usage in `df -P|awk 'NR>=2{print$5}'|tr -d "%"`
do
        if [ "$disk_usage" -ge 90 ];then
                disk="\n磁盘剩余不足 `df -h|grep -w $disk_usage`"
                wx "$(cur_time) \n$(hostname) $ip\n$disk \n请检查！！！"
        fi
done
