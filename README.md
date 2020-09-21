# Docker Run RKE

This repo provides a simple Dockerfile to build a doker-rke image with additional tools to deploy a Rancher Kubernetes Engine (RKE) Cluster and use HELM to deploy the Rancher Management Server on top of our first RKE Cluster and use Rancher to deploy other RKE clusters on different stages.

I assume you have Ubuntu LTS (e.g. 18.04) installed on all machines (rke nodes) with Docker 19.x version in place. You need 3 VMs to have an HA Rancher.

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/rancher-rke-key.pem -C <your email>
## you have to add the rancher-rke-key.pem.pub to .ssh/authorized_keys on rke hosts, or use ssh-copy-id!!!
git clone https://github.com/arashkaffamanesh/docker-rke
docker build -t kubernautslabs/docker-rke .
docker run -it --rm -v "$PWD:/tmp" -v "$HOME/.ssh/:/root/.ssh" kubernautslabs/docker-rke
## You should jump into the container
root@xyz:~# cd /tmp
## Provide the rke hosts entries in /etc/hosts in the container
root@xyz:~# vi /etc/hosts
192.168.64.14 rke1
192.168.64.15 rke2
192.168.64.17 rke3
root@xyz:~# rke up
## If the deployment goes well, please try
root@xyz:~# export KUBECONFIG=kube_config_cluster.yml
root@xyz:~# kubectl get all -A
```

# Deploy Rancher with HELM


