#!/bin/bash
#!
dir=/etc/yum.repos.d   #Yum source
[ `id -u` -ne 0 ] && echo "Please use the root user to execute $0"&&exit 1
menu(){
echo "Please Correct Input [1-8] Begin install"
echo "-----------------------------------"
echo "Input $0 1 install ftp yum source"
echo "Input $0 2 install iso yum source"
echo "Input $0 3 install aliyun Centos-5.repo"
echo "Input $0 4 install aliyun Centos-6.repo"
echo "Input $0 5 install aliyun Centos-7.repo"
echo "Input $0 6 install 163 CentOS5-Base-163.repo"
echo "Input $0 7 install 163 CentOS6-Base-163.repo"
echo "Input $0 8 install 163 CentOS7-Base-163.repo"
echo "-----------------------------------"
}
backup(){
echo "-----------------------------------"
echo "Begin backup  $dir"
echo "-----------------------------------"
mkdir -p $dir/backup
mv -f $dir/*.repo $dir/backup  
echo "Backup yum files success" 
echo "Backup yum directory "$dir"backup"  
echo "-----------------------------------"
}
clean_yum_cache(){
echo "-----------------------------------"
echo "Begin clean yum all cache"
echo "-----------------------------------"
yum clean all
yum makecache 
echo "-----------------------------------"
echo "$0 script execution end"
echo "-----------------------------------"
}
aliyun_mirrors(){
echo "Testing http://mirrors.aliyun.com/repo/ connectivity"
echo "-----------------------------------"
aliyun=`curl --connect-timeout 10 -I http://mirrors.aliyun.com/repo/|head -n 1|grep 200|wc -l`
  if [ $aliyun -ne 1 ];then
    echo "-----------------------------------"
    echo "mirrors.aliyun.com yum source is unavailable"  
    exit 1
  fi
}
m163_mirrors(){
echo "Testing http://mirrors.163.com/.help/centos.html connectivity"
echo "-----------------------------------"
m163=`curl --connect-timeout 10 -I http://mirrors.163.com/.help/centos.html|head -n 1|grep 200|wc -l`
  if [ $m163 -ne 1 ] ;then
    echo "-----------------------------------"
    echo "mirrors.163.com yum source is unavailable" 
    exit 1
  fi
}
case $1 in
  1 ) 
      read -p "Please enter the ftp Server ipaddress and path:" ip
      ping -c 2 $ip >/dev/null 2>&1
      if [ $? -ne 0 ];then
        echo "Input ipaddress:$ftpip Host Unreachable "
        echo "Please enter ftp Server ipaddress"
        exit 1
      else
        backup
        cat >  $dir/base.repo << EOF
[base]
name=base
baseurl=ftp://$ip/pub
enabled=1
gpgcheck=0  
EOF
        clean_yum_cache
      fi
    ;;
  2 ) 
      read -p "Please enter the ISO file path :" iso 
      if [ -z $iso ]; then
        echo "Please enter the ISO file path:(/dev/sr0)"
        exit 1
      elif [ -b $iso ] || [ -f $iso ] ;then
        backup
              if [ ! -d  "/yumiso" ] ;then
                    mkdir -p /yumiso
                else 
                  echo "/yumiso mount directory already exists"
              fi
        mount -o loop $iso /yumiso
        cat > $dir/base.repo <<EOF
[base]
name=base
baseurl=file:///yumiso
enabled=1
gpgcheck=0
EOF
      else         
        echo "Please enter the ISO file path:(/dev/sr0)"
        exit 1
      fi
      clean_yum_cache
    ;;
  3 ) 
      aliyun_mirrors
      backup
      cd $dir
      wget http://mirrors.aliyun.com/repo/Centos-5.repo
      clean_yum_cache
    ;;
  4 ) 
      aliyun_mirrors
      backup
      cd $dir
      wget http://mirrors.aliyun.com/repo/Centos-6.repo
      clean_yum_cache
    ;;
  5 ) 
      aliyun_mirrors
      backup
      cd $dir
      wget http://mirrors.aliyun.com/repo/Centos-7.repo
      clean_yum_cache
    ;;
  6 ) 
      m163_mirrors
      backup
      cd $dir
      wget http://mirrors.163.com/.help/CentOS5-Base-163.repo
      clean_yum_cache
    ;;
  7 ) 
      m163_mirrors
      backup
      cd $dir
      wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
      clean_yum_cache
    ;;
  8 ) 
      m163_mirrors
      backup
      cd $dir
      wget http://mirrors.163.com/.help/CentOS7-Base-163.repo
      clean_yum_cache
    ;;
  * )
      menu
      exit
    ;;
esac

