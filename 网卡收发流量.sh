#rx是接收(receive)
rx=`ifstat|awk '/eth0/{print$2"kb"}'`
#tx是发送（transport）
tx=`ifstat|awk '/eth0/{print$4"kb"}'`
sleep 1
rx=`ifstat|awk '/eth0/{print$2"kb"}'`
#tx是发送（transport）
tx=`ifstat|awk '/eth0/{print$4"kb"}'`
echo $rx $tx
#发送流量：$($tx)kb 接收流量：$($rx)kb