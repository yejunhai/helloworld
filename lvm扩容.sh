#查看剩余空间
vgs
#剩余空间100%都扩容到根(/)目录
lvextend -l +100%FREE  `df |grep -w '/'|awk '{print$1}'`
#扫描磁盘识别已扩容空间，CentOS7默认磁盘为xfs文件系统
xfs_growfs `df|grep -w '/'|awk '{print$1}'` 
#--------------------------------------------------------------
#只需替换grep -w '目录'，例：剩余空间都扩容到/opt目录
lvextend -l +100%FREE  `df|grep -w '/opt'|awk '{print$1}'`
xfs_growfs `df|grep -w '/opt'|awk '{print$1}'`
#扩容指定大小，例：扩容10g给根（/）目录
lvextend -L +10g `df|grep -w '/'|awk '{print$1}'`
xfs_growfs `df|grep -w '/opt'|awk '{print$1}'`
#扫描磁盘识别已扩容空间，CentOS6默认磁盘格式为ext2\3\4需要执行以下命令
resize2fs `df|grep -w '/'|awk '{print$1}'`