#!/usr/bin/env bash

apt-get update
apt-get install build-essential gnupg software-properties-common -y

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list

apt update
apt-get install terraform

touch /home/vagrant/.bashrc
terraform -install-autocomplete

curl https://releases.rancher.com/install-docker/20.10.sh | sh
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" K3S_KUBECONFIG_MODE="777" sh -s - --docker --cluster-init

apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl

apt-get install bash-completion
source /usr/share/bash-completion/bash_completion

kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
chmod a+r /etc/bash_completion.d/kubectl

echo 'alias k=kubectl' >>/home/vagrant/.bashrc
echo 'KUBECONFIG=~/.kube/config.yaml' >>/home/vagrant/.bashrc
echo 'complete -o default -F __start_kubectl k' >>/home/vagrant/.bashrc

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get update
apt-get install helm

mkdir /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config.yaml
chown 0755 /home/vagrant/.kube/config.yaml

kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml apply -f /vagrant/manifests/traefik.yaml

tee -a /etc/hosts <<EOF
127.0.0.1 localhost
127.0.0.1 testnet.structx.local
EOF
