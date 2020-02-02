#!/bin/bash
#centos7
if [ `free|awk '/Mem:/{printf "%d",$4/$2*100}'` -le 10 ];then
  # free内存小于等于10% 开始清理
        sync
        echo 1 > /proc/sys/vm/drop_caches
        echo 2 > /proc/sys/vm/drop_caches
        echo 3 > /proc/sys/vm/drop_caches
fi