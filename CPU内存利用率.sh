#!/bin/bash
#CPU利用率: $cpu
cpu=`top -n 1|awk '/%Cpu/{printf("%.2f%\n",(100-$8))}'`
#内存利用率: $mem "
mem=`free|awk '/Mem:/{printf("%.2f%\n",($2-$4)/$2*100)}'`

