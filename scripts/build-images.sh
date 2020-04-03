#!/bin/bash

set +x

. ./set-env.sh

if [ -z "${IS_MINIKUBE}" ] 
then
    echo "Set IS_MINIKUBE in ./set-env.sh"
    exit 1
fi

if [ -z "${DOCKER_LOGIN}" ] 
then
    echo "Set DOCKER_LOGIN in ./set-env.sh"
    exit 1
fi

if [ -z "${DOCKER_PWD}" ] 
then
    echo "Set DOCKER_PWD in ./set-env.sh"
    exit 1
fi

if [ ${IS_MINIKUBE} -eq 1 ] ; then
    eval $(minikube docker-env)
fi

cd ../k8s

docker build -f Dockerfile.mysql-client -t ${DOCKER_LOGIN}/mysql-client:1.0 .
docker build -f Dockerfile.wget -t ${DOCKER_LOGIN}/wget:1.0 .

if [ ${IS_MINIKUBE} -eq 1 ] ; then
    eval $(minikube docker-env --unset)
fi

cd ../scripts


