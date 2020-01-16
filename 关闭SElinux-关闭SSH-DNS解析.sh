#!/bin/bash
sed -i "s/#UseDNS yes/UseDNS no/" /etc/ssh/sshd_config
setenforce 0 && sed -i 's/enforcing/disabled/g' /etc/selinux/config 

