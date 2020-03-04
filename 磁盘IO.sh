#磁盘读：
read=`iostat|awk '/.da/{print$3 "kb/s"}'`
#磁盘写：
write=`iostat|awk '/.da/{print$4 "kb/s"}'`
#IO利用率：
io=`iostat -x|awk '/.da/{print$14"%"}'`