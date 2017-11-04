#!/bin/sh

echo 'START ETCD'

sed 's/localhost/0.0.0.0/' -i /etc/etcd/etcd.conf
sed 's/# KUBE_API_PORT/KUBE_API_PORT/' -i /etc/kubernetes/apiserver
sed 's/# KUBELET_PORT/KUBELET_PORT/' -i /etc/kubernetes/apiserver
sed 's/KUBE_API_ADDRESS=.*/KUBE_API_ADDRESS=\"--address=0.0.0.0\"/' -i /etc/kubernetes/apiserver
sed 's/KUBE_ETCD_SERVERS=.*/KUBE_ETCD_SERVERS=\"--etcd-servers=http:\/\/centos-mmmaster:2379\"/' -i /etc/kubernetes/apiserver

systemctl start etcd
etcdctl mkdir /kube-centos/network
etcdctl mk /kube-centos/network/config "{ \"Network\": \"172.30.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"