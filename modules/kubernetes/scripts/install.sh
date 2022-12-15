#!/bin/bash
set -euo pipefail

systemctl daemon-reload

apt-get -o Acquire::ForceIPv4=true -qq update
apt-get -o Acquire::ForceIPv4=true -qq install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL -4  https://download.docker.com/linux/ubuntu/gpg | apt-key add -
curl -fsSL -4  https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/docker-and-kubernetes.list
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
deb http://packages.cloud.google.com/apt/ kubernetes-xenial main
EOF

apt-get -o Acquire::ForceIPv4=true -qq update
apt-get -o Acquire::ForceIPv4=true -qq install -y docker-ce
apt-get -o Acquire::ForceIPv4=true -qq install -y kubelet=${kubernetes_version}-* kubeadm=${kubernetes_version}-* kubectl=${kubernetes_version}-*
sysctl -p




# #!/bin/bash
# set -euo pipefail

# systemctl daemon-reload

# apt-get -o Acquire::ForceIPv4=true update
# apt-get -o Acquire::ForceIPv4=true install -y \
#     apt-transport-https \
#     ca-certificates \
#     curl \
#     software-properties-common

# curl -fsSL -4 https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# curl -fsSL -4 https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
# cat <<EOF > /etc/apt/sources.list.d/docker-and-kubernetes.list
# deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
# deb http://packages.cloud.google.com/apt/ kubernetes-xenial main
# EOF

# echo "1"
# apt-get -o Acquire::ForceIPv4=true update
# echo "2"
# apt-get -o Acquire::ForceIPv4=true install -y docker-ce
# echo "3"
# apt-get -o Acquire::ForceIPv4=true install -y kubelet=${kubernetes_version}-* kubeadm=${kubernetes_version}-* kubectl=${kubernetes_version}-*
# sysctl -p
