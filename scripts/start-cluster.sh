#!/bin/bash

set -e
set -x

. ./set-env.sh

minikube start -p $CLUSTER1_NAME --memory='6000mb' --cpus=4 --disk-size=40g --vm-driver="hyperkit" --insecure-registry=localhost:5000 --kubernetes-version=1.18.0 
# minikube start -p $CLUSTER1_NAME --extra-config kubelet.EnableCustomMetrics=true
minikube profile $CLUSTER1_NAME
minikube addons enable ingress
# minikube addons enable metrics-server
minikube addons list

eval $(minikube docker-env)

kubectl config use-context $CLUSTER1_NAME
# minikube -p $CLUSTER1_NAME dashboard
# octant