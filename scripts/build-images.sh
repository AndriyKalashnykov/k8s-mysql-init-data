#!/bin/bash

eval $(minikube docker-env)

cd ../k8s

docker build -f Dockerfile.mysql-client -t akalashnykov/mysql-client:1.0 .
docker build -f Dockerfile.wget -t akalashnykov/wget:1.0 .

cd ../scripts


