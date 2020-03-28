#!/bin/bash

. ./set-env.sh


eval $(minikube docker-env)

kubectl create namespace $NS_NAME

# create PVC
kubectl apply -f ../k8s/mysql-pvc.yaml -n $NS_NAME
kubectl get persistentvolumeclaim mysql-data-disk -n $NS_NAME
kubectl describe persistentvolumeclaim mysql-data-disk -n $NS_NAME

kubectl create -f ../k8s/mysql-secret.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-cm.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-pod.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-svc.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-client-pod.yaml -n $NS_NAME