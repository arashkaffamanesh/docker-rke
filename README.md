# Docker Run RKE

```
docker run -it -v "$PWD:/tmp" -v "$HOME/.ssh/:/root/.ssh" kubernautslabs/docker-rke
```

## Provide the hosts entries in /etc/hosts

```
vi /etc/hosts

192.168.64.14 rke1
192.168.64.15 rke2
192.168.64.17 rke3

cd /tmp/

rke up

export KUBECONFIG=kube_config_cluster.yml

k get all -A
```
