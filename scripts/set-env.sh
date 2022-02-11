#!/bin/bash

export DOCKER_LOGIN=
export DOCKER_PWD=
export DOCKER_REGISTRY=registry-1.docker.io

# 1 - if deploying to local Minikube cluster, 0 - otherwise
export IS_MINIKUBE=0

export CLUSTER1_NAME=minikube-cluster-1

export KUBECTL_TIMEOUT=900
export NS_NAME=mysql
export MYSQL_POD_NAME=mysql
export MYSQL_CLIENT_POD_NAME=mysql-client


