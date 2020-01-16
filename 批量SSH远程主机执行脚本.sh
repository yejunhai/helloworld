#!/bin/bash
#linux20190606
#list.txt文件格式：IP 登入密码 新密码

createsh(){
echo "开始创建脚本auto.sh "
cat >> auto.sh <<-EOF
#!/bin/bash
echo "开始执行脚本"

echo "脚本执行成功" && exit 0
EOF
echo "创建脚本auto.sh完成"
}

createexp(){
echo "开始创建自动登入脚本ssh.exp"
cat >> ssh.exp <<-EOF
#!/usr/bin/expect
set passwd [lindex \$argv 0]
set host [lindex \$argv 1]
set shell [lindex \$argv 2]
set newpasswd [lindex \$argv 3]
spawn scp $shell root@\$host:$shell
expect {
    "yes/no" { send "yes\r"; exp_continue}
    "password:" { send "\$passwd\r" }
}
spawn ssh  root@\$host
expect {
    "yes/no" { send "yes\r"; exp_continue}
    "password:" { send "\$passwd\r" }
}
expect "]*"
send "echo '\$newpasswd'|passwd --stdin root || exit 1 \r"
expect "]*"
send "sh $shell \r"
expect "]*"
send "\[ -f $shell \] && rm -f $shell \r"
expect "]*"
send "exit\r"
expect eof
EOF
echo "创建脚本ssh.exp完成"
}

[ `id -u` -ne 0 ] && echo "请使用root用户执行 $0"&&exit 1 
[ -f /root/auto.sh ] && rm -f /root/auto.sh && echo "删除旧auto.sh文件"
createsh 
shell=/root/auto.sh
ipfile=/root/list.txt
[ -f $ipfile ] || echo "/root/list.txt路径下文件不存在 list.txt文件格式：IP 登入密码 新密码"
[ -f /root/ssh.exp ] && rm -f /root/ssh.exp && echo "删除旧ssh.exp文件"
createexp

while read line 
do
    ip=`echo $line|awk '{print $1}'`
    pw=`echo $line|awk '{print $2}'`
	newpw=`echo $line|awk '{print $3}'`
	if [ -z $ip  ]||[ -z $pw  ]||[ -z $newpw  ];then
			echo "list.txt文件在$ip $pw $newpw有错误 文件格式：IP 登入密码 新密码"
			exit 1
	elif [ -f $shell ]; then
		ping -c 1 $ip >/dev/null 2>&1
			if [ $? -eq 0 ] ;then
				echo "登入主机 $ip "	
			else
				echo "主机$ip无法访问 请检查网络连接"
			exit 1
			fi 
		echo "复制到主机$ip自动运行脚本auto.sh 日志$0.log" |tee -a /root/$0.log	
	else
		echo "脚本文件auto.sh未找到" 
		exit 1
	fi
    /usr/bin/expect /root/ssh.exp $pw $ip $shell $newpw
done <$ipfile

echo "删除本地脚本文件"
[ -f /root/ssh.exp ] && rm -f /root/ssh.exp
[ -f /root/auto.sh ] && rm -f /root/auto.sh
echo > ~/.ssh/known_hosts
echo "$(date +"%Y/%m/%d %H:%M.%S") $0脚本执行结束" |tee -a /root/$0.log
cat list.txt >> list.bk
echo "显示日志"
ls /root/*.log 
exit 0

