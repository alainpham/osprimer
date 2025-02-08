#!/bin/bash

# https://github.com/rancher/local-path-provisioner
export LOCAL_PATH_PROVISIONER_VERSION=v0.0.31

# https://github.com/kubernetes/ingress-nginx/blob/main/deploy/static/provider/baremetal/deploy.yaml
export NGINX_INGRESS_VERSION=1.12.0
export NGINX_INGRESS_KUBE_WEBHOOK_CERTGEN_VERSION=v1.5.0

# https://github.com/kubernetes-sigs/metrics-server
export METRICS_SERVER_VERSION=v0.7.2

# sudo kubeadm init --control-plane-endpoint=v8s.duckdns.org  --pod-network-cidr=10.244.0.0/16


kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl taint node ${HOSTNAME} node-role.kubernetes.io/control-plane:NoSchedule-

wget -O /tmp/local-path-provisioner.yaml https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/k8s/local-path-provisioner.yaml
envsubst '${LOCAL_PATH_PROVISIONER_VERSION}'  < /tmp/local-path-provisioner.yaml | kubectl apply -f -

wget -O /tmp/metrics-server.yaml https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/k8s/metrics-server.yaml
envsubst < /tmp/metrics-server.yaml | kubectl apply -f -

kubectl create ns ingress-nginx
kubectl -n ingress-nginx create secret tls nginx-ingress-tls  --key="/home/${USER}/apps/tls/cfg/live/${WILDCARD_DOMAIN}/privkey.pem"   --cert="/home/${USER}/apps/tls/cfg/live/${WILDCARD_DOMAIN}/fullchain.pem"  --dry-run=client -o yaml | kubectl apply -f -

wget -O /tmp/ingress.yaml https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/k8s/ingress-hostport-notoleration.yaml
envsubst < /tmp/ingress.yaml | kubectl -n ingress-nginx apply -f -