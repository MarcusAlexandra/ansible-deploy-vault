[root@utrutstetcd01v cfssL]# etcdctl --debug --no-sync --endpoints https://utrutstetcd01v.dynataplc.com:2379 --ca-file /etc/etcd/cfssL/ca.crt --cert-file /etc/etcd/cfssL/server.crt --key-file /etc/etcd/cfssL/server.key member list
Cluster-Endpoints: https://utrutstetcd01v.dynataplc.com:2379
cURL Command: curl -X GET https://utrutstetcd01v.dynataplc.com:2379/v2/members
cURL Command: curl -X GET https://utrutstetcd01v.dynataplc.com:2379/v2/members/leader
59a94dbda18330a: name=utrutstetcd01v peerURLs=https://utrutstetcd01v.dynataplc.com:2380 clientURLs=https://utrutstetcd01v.dynataplc.com:2379 isLeader=true
3291aab4fb356719: name=utrutstetcd03v peerURLs=https://utrutstetcd03v.dynataplc.com:2380 clientURLs=https://utrutstetcd03v.dynataplc.com:2379 isLeader=false
926b1dd40e21695c: name=utrutstetcd02v peerURLs=https://utrutstetcd02v.dynataplc.com:2380 clientURLs=https://utrutstetcd02v.dynataplc.com:2379 isLeader=false
[root@utrutstetcd01v cfssL]#

[root@utrutstetcd01v cfssL]# etcdctl --debug --no-sync --endpoints https://utrutstetcd01v.dynataplc.com:2379 --ca-file /etc/etcd/cfssL/ca.crt --cert-file /etc/etcd/cfssL/server.crt --key-file /etc/etcd/cfssL/server.key cluster-health
Cluster-Endpoints: https://utrutstetcd01v.dynataplc.com:2379
cURL Command: curl -X GET https://utrutstetcd01v.dynataplc.com:2379/v2/members
member 59a94dbda18330a is healthy: got healthy result from https://utrutstetcd01v.dynataplc.com:2379
member 3291aab4fb356719 is healthy: got healthy result from https://utrutstetcd03v.dynataplc.com:2379
member 926b1dd40e21695c is healthy: got healthy result from https://utrutstetcd02v.dynataplc.com:2379
cluster is healthy
[root@utrutstetcd01v cfssL]#


[root@utrutstetcd01v ~]# curl -s -k GET  https://utrutstetcd01v.dynataplc.com:2379/v2/members | jq
{
  "members": [
    {
      "id": "59a94dbda18330a",
      "name": "utrutstetcd01v",
      "peerURLs": [
        "https://utrutstetcd01v.dynataplc.com:2380"
      ],
      "clientURLs": [
        "https://utrutstetcd01v.dynataplc.com:2379"
      ]
    },
    {
      "id": "3291aab4fb356719",
      "name": "utrutstetcd03v",
      "peerURLs": [
        "https://utrutstetcd03v.dynataplc.com:2380"
      ],
      "clientURLs": [
        "https://utrutstetcd03v.dynataplc.com:2379"
      ]
    },
    {
      "id": "926b1dd40e21695c",
      "name": "utrutstetcd02v",
      "peerURLs": [
        "https://utrutstetcd02v.dynataplc.com:2380"
      ],
      "clientURLs": [
        "https://utrutstetcd02v.dynataplc.com:2379"
      ]
    }
  ]
}
[root@utrutstetcd01v ~]#
