#磁盘读：
iostat|awk '/.da/{print$3 "kb/s"}'
#磁盘写：
iostat|awk '/.da/{print$4 "kb/s"}'
#IO利用率：
iostat -x|awk '/.da/{print$14"%"}'