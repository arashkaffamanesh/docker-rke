# Docker Run RKE

This repo provides a simple Dockerfile to build a doker-rke image with additional tools to deploy a Rancher Kubernetes Engine (RKE) Cluster and use HELM to deploy the Rancher Management Server on top of our first RKE Cluster and use Rancher to deploy other RKE clusters on different stages.

I assume you have Ubuntu LTS (e.g. 18.04) installed on all machines (rke nodes) with Docker 19.x version in place. You need 3 VMs to have an HA Rancher.

```
ssh-keygen -t rsa -b 4096 -f ~/.ssh/rancher-rke-key.pem -C <your email>
## you have to add the rancher-rke-key.pem.pub to .ssh/authorized_keys on rke hosts, or use ssh-copy-id!!!
## Please make sure the user (in our case ubuntu) or whatever user has been added to the docker group
sudo usermod -aG docker <user name>
git clone https://github.com/arashkaffamanesh/docker-rke && cd docker-rke

# optional step
docker build -t kubernautslabs/docker-rke .

docker run --name docker-rke -it -d -v "$PWD:/tmp" -v "$HOME/.ssh/:/root/.ssh" kubernautslabs/docker-rke

# optional step
docker ps 

# exec the container
docker exec -it docker-rke bash

## the rke config expects three dns host entries
echo '192.168.64.14 rke1
192.168.64.15 rke2
192.168.64.17 rke3' >> /etc/hosts

# start the rke three node deployment
rke up --config ./cluster-extended.yml

## If the deployment goes well, please try
export KUBECONFIG=kube_config_cluster.yml
kubectl get nodes
```

# Deploy Rancher with HELM

If using Private CA

```
kubectl create namespace cattle-system

kubectl -n cattle-system create secret tls tls-rancher-ingress \
  --cert=tls.crt \
  --key=tls.key

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.my.org \
  --set ingress.tls.source=secret \
  --set privateCA=true


