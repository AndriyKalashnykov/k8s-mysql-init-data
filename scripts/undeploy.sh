#!/bin/bash

. ./set-env.sh

kubectl delete -f ../k8s/mysql-client-pod.yaml -n $NS_NAME

kubectl delete -f ../k8s/mysql-secret.yaml -n $NS_NAME
kubectl delete -f ../k8s/mysql-cm.yaml -n $NS_NAME
kubectl delete -f ../k8s/mysql-pod.yaml -n $NS_NAME
kubectl delete -f ../k8s/mysql-svc.yaml -n $NS_NAME
kubectl delete -f ../k8s/mysql-pvc.yaml -n $NS_NAME

kubectl delete namespace $NS_NAME --force=true --grace-period=0