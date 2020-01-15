#!/bin/bash
#20190814
. /root/weixin.sh
cur_time(){
        date "+%Y/%m/%d %H:%M:%S"
}

systemname(){
name=`cat url2.txt|grep $url|wc -l`
if [ $name -eq 1 ];then
	cat url2.txt|grep -w $url
else
        echo "$url"
fi
}

[ ! -f /root/url.txt ] && echo "url.txt文件不存在" && exit 1
sed -i '/^$/d' url.txt
while read url
do
	[ -z $url  ] && echo "url.txt存在空格 检查文件格式" && exit 1
        for ((i=1;i<7;i++))
        do
                rule1=`curl -i -s -k -L -m 15 $url|grep "200 OK"|wc -l`
                if [ $rule1 -eq 1 ];then
                	echo "$(cur_time) 第$i次检查$url网页访问成功" >> check.log
			break
		fi
		rule2=`curl -i -s -k -L -m 15 $url|sed -n '1p'|grep "200"|wc -l`
		if [ $rule2 -eq 1 ];then
			echo "$(cur_time) 第$i次检查$url网页访问成功" >> check.log
			break
                elif [ $i = 6 ];then
			info=`echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"`
			wx_web
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" 1340998782@qq.com
			#echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" chenfq@nebulabd.cn
			#echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" chensit@nebulabd.cn
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" linlz@nebulabd.cn
			#echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" linrc@nebulabd.cn
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" yangl@nebulabd.cn
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" yanzx@nebulabd.cn
			#echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" yums@nebulabd.cn
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!"|mail -s "【重要告警】网页不可达" zhuangrg@nebulabd.cn
			echo "$(cur_time) $(systemname) 网页$(expr $i \* 10)秒无法访问，请检查!" >> checkfail.log
			echo $url >> url.del
                else
			echo "$(cur_time) 第$i次检查$url网页访问失败" >> checkfail.log
			sleep 10
                fi

        done
done < /root/url.txt

sh /root/checkdel.sh
sh /root/checkadd.sh
