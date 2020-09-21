#!/bin/bash
export KUBECONFIG=kube_config_cluster.yml

# Use own CA certs and keys with mkcert
# install mkcert
# brew install mkcert
# mkcert — install
# linux
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64
mv mkcert-v1.4.1-linux-amd64 /usr/local/bin/mkcert
chmod +x /usr/local/bin/mkcert
mkcert '*.rancher.svc'
# on MacOS
# cp $HOME/Library/Application\ Support/mkcert/rootCA.pem cacerts.pem
# on Ubuntu Linux
cp .local/share/mkcert/rootCA.pem cacerts.pem
cp _wildcard.rancher.svc.pem cert.pem
cp _wildcard.rancher.svc-key.pem key.pem
# in /etc/hosts set
# 192.168.64.14 gui.rancher.svc rke1
# the ip 192.168.64.14 can be any ip of rke1, rke2 or rke3
sudo echo "192.168.64.14 gui.rancher.svc" >> /etc/hosts
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create ns cattle-system
kubectl -n cattle-system create secret generic tls-ca --from-file=./cacerts.pem
kubectl -n cattle-system create secret tls tls-rancher-ingress --cert=./cert.pem --key=./key.pem
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=gui.rancher.svc  --set ingress.tls.source=secret --set privateCA=true
echo "############################################################################"
echo "This should take about 4 minutes, wait for the browser to pop up and enjoy :-)"
echo "############################################################################"
kubectl -n cattle-system rollout status deploy/rancher
# open https://gui.rancher.svc 
# you should get a vaild cert





