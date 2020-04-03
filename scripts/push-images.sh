#!/bin/bash

. ./set-env.sh

set +x

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

docker login --username=${DOCKER_LOGIN} --password ${DOCKER_PWD} ${DOCKER_REGISTRY}

docker push ${DOCKER_LOGIN}/mysql-client:1.0
docker push ${DOCKER_LOGIN}/wget:1.0