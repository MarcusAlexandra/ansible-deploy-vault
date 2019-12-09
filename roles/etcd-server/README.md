[root@usctvletcd01v cfssL]# etcdctl --debug --no-sync --endpoints https://usctvletcd01v.curbstone.com:2379 --ca-file /etc/etcd/cfssL/ca.crt --cert-file /etc/etcd/cfssL/server.crt --key-file /etc/etcd/cfssL/server.key member list
Cluster-Endpoints: https://usctvletcd01v.curbstone.com:2379
cURL Command: curl -X GET https://usctvletcd01v.curbstone.com:2379/v2/members
cURL Command: curl -X GET https://usctvletcd01v.curbstone.com:2379/v2/members/leader
59a94dbda18330a: name=usctvletcd01v peerURLs=https://usctvletcd01v.curbstone.com:2380 clientURLs=https://usctvletcd01v.curbstone.com:2379 isLeader=true
3291aab4fb356719: name=usctvletcd03v peerURLs=https://usctvletcd03v.curbstone.com:2380 clientURLs=https://usctvletcd03v.curbstone.com:2379 isLeader=false
926b1dd40e21695c: name=usctvletcd02v peerURLs=https://usctvletcd02v.curbstone.com:2380 clientURLs=https://usctvletcd02v.curbstone.com:2379 isLeader=false
[root@usctvletcd01v cfssL]#

[root@usctvletcd01v cfssL]# etcdctl --debug --no-sync --endpoints https://usctvletcd01v.curbstone.com:2379 --ca-file /etc/etcd/cfssL/ca.crt --cert-file /etc/etcd/cfssL/server.crt --key-file /etc/etcd/cfssL/server.key cluster-health
Cluster-Endpoints: https://usctvletcd01v.curbstone.com:2379
cURL Command: curl -X GET https://usctvletcd01v.curbstone.com:2379/v2/members
member 59a94dbda18330a is healthy: got healthy result from https://usctvletcd01v.curbstone.com:2379
member 3291aab4fb356719 is healthy: got healthy result from https://usctvletcd03v.curbstone.com:2379
member 926b1dd40e21695c is healthy: got healthy result from https://usctvletcd02v.curbstone.com:2379
cluster is healthy
[root@usctvletcd01v cfssL]#
