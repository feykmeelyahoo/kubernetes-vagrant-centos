#!/bin/sh

echo 'INSTALL KUBERNETES'

cat <<EOF > /etc/yum.repos.d/virt7-docker-common-release.repo
[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
EOF
yum -y install --enablerepo=virt7-docker-common-release kubernetes etcd flannel

cat <<EOF > /etc/hosts
192.168.121.9	centos-master
192.168.121.65	centos-minion-1
192.168.121.66	centos-minion-2
192.168.121.67	centos-minion-3
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
EOF

echo 'STOPPING FIREWALL SERVICES...'
setenforce 0
systemctl disable firewalld
systemctl stop firewalld
echo 'STOPPED FIREWALL SERVICES...'
