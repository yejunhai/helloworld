#CENT 7版本挂载本地yum源
mount /dev/sr0 /mnt 
yum-config-manager --add-repo="file:///mnt"
yum clean all && yum makecache

#CENT 6&7版本挂载本地yum源
mount /dev/sr0 /mnt
cat > /etc/yum.repos.d/base.repo <<EOF
[base]
name=base
baseurl=file:///mnt
enabled=1
gpgcheck=0
EOF
yum clean all && yum makecache