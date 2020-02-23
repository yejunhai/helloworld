tx是发送（transport），rx是接收(receive)

rx=`ifstat|awk '/eth0/{print$2}'`

tx=`ifstat|awk '/eth0/{print$4}'`

echo "发送流量：$($tx)kb 接收流量：$($rx)kb"