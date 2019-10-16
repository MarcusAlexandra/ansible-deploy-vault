#!/bin/bash

# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -o errexit
set -o nounset
set -o pipefail

# Export proxy to ensure commands like curl could work
[[ -n "${HTTP_PROXY:-}" ]]  && export HTTP_PROXY=${HTTP_PROXY}
[[ -n "${HTTPS_PROXY:-}" ]] && export HTTPS_PROXY=${HTTPS_PROXY}

# Caller should set in the ev:
# NODE_IPS - IPs of all etcd servers
# NODE_DNS - DNS names of all etcd servers
# ARCH - what arch of cfssl should be downloaded

# Also the following will be respected
# CERT_DIR - where to place the finished certs
# CERT_GROUP - who the group owner of the cert files should be

node_ips="${NODE_IPS:="${1}"}"
node_dns="${NODE_DNS:="${2}"}"
arch="${ARCH:-"linux-amd64"}"
cert_dir="${CERT_DIR:-"/srv/kubernetes"}"
cert_group="${CERT_GROUP:="etcd"}"

# The following certificate pairs are created:
#
#  - ca (the cluster's certificate authority)
#  - server (for etcd access)
#  - client (for kube-apiserver, etcdctl)
#  - peer (for etcd peer to peer communication)

tmpdir=$(mktemp -d --tmpdir etcd_cacert.XXXXXX)
trap 'rm -rf "${tmpdir}"' EXIT
cd "${tmpdir}"

declare -a san_array=()

IFS=',' read -ra node_ips <<< "$node_ips"
for ip in "${node_ips[@]}"; do
    san_array+=(${ip})
done
IFS=',' read -ra node_dns <<< "$node_dns"
for dns in "${node_dns[@]}"; do
    san_array+=(${dns})
done

mkdir -p bin
curl -sSL -o ./bin/cfssl "https://pkg.cfssl.org/R1.2/cfssl_$arch"
curl -sSL -o ./bin/cfssljson "https://pkg.cfssl.org/R1.2/cfssljson_$arch"
chmod +x ./bin/cfssl{,json}
export PATH="$PATH:${tmpdir}/bin/"

cat <<EOF > ca-config.json
{
    "signing": {
        "default": {
            "expiry": "87600h"
        },
        "profiles": {
            "server": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "87600h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF
cat <<EOF > ca-csr.json
{
    "CN": "ssi.io",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
          "O": "Marcus-Alexandra, LLC ",
          "OU": "Marcus-Alexandra.io DevOps",
          "L": "Shelton",
          "ST": "Connecticut",
          "C": "US"
        }
    ]
}
EOF
if ! (cfssl gencert -initca ca-csr.json | cfssljson -bare ca -) >/dev/null 2>&1; then
    echo "=== Failed to generate CA certificates: Aborting ===" 1>&2
    exit 2
fi
cn_name="${san_array[0]}"
san_array=("${san_array[@]}")
set -- ${san_array[*]}
for arg do shift
    set -- "$@" \",\" "$arg"
done; shift
hosts_string="\"$(printf %s "$@")\""
cat <<EOF > server.json
{
    "CN": "$cn_name",
    "hosts": [
        "127.0.0.1",
        "::1",
        "::",
        $hosts_string
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
          "O": "Marcus-Alexandra, LLC ",
          "OU": "Marcus-Alexandra.io DevOps",
          "L": "Shelton",
          "ST": "Connecticut",
          "C": "US"
        }
    ]
}
EOF

if ! (cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=server server.json | cfssljson -bare server) >/dev/null 2>&1; then
    echo "=== Failed to generate server certificates: Aborting ===" 1>&2
    exit 2
fi

cat <<EOF > client.json
{
    "CN": "$cn_name",
    "hosts": [""],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
          "O": "Marcus-Alexandra, LLC ",
          "OU": "Marcus-Alexandra.io DevOps",
          "L": "Shelton",
          "ST": "Connecticut",
          "C": "US"
        }
    ]
}
EOF

if ! (cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client client.json | cfssljson -bare client) >/dev/null 2>&1; then
    echo "=== Failed to generate client certificates: Aborting ===" 1>&2
    exit 2
fi

cat <<EOF > peer.json
{
    "CN": "$cn_name",
    "hosts": [
        "127.0.0.1",
        "::1",
        "::",
        $hosts_string
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
          "O": "Marcus-Alexandra, LLC ",
          "OU": "Marcus-Alexandra.io DevOps",
          "L": "Shelton",
          "ST": "Connecticut",
          "C": "US"
        }
    ]
}
EOF

if ! (cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=peer peer.json | cfssljson -bare peer) >/dev/null 2>&1; then
    echo "=== Failed to generate peer certificates: Aborting ===" 1>&2
    exit 2
fi

mkdir -p "$cert_dir"

cp -p ca.pem "${cert_dir}/ca.crt"
cp -p server.pem "${cert_dir}/server.crt"
cp -p server-key.pem "${cert_dir}/server.key"
cp -p client.pem "${cert_dir}/client.crt"
cp -p client-key.pem "${cert_dir}/client.key"
cp -p peer.pem "${cert_dir}/peer.crt"
cp -p peer-key.pem "${cert_dir}/peer.key"

CERTS=("ca.crt" "server.crt" "server.key" "client.crt" "client.key" "peer.crt" "peer.key")
for cert in "${CERTS[@]}"; do
  chgrp "${cert_group}" "${cert_dir}/${cert}"
  chmod 660 "${cert_dir}/${cert}"
done
