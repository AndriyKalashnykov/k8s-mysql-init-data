#!/bin/bash

. ./set-env.sh

set +x

docker login --username=${DOCKER_LOGIN} --password ${DOCKER_PWD} ${DOCKER_REGISTRY}

docker push ${DOCKER_LOGIN}/mysql-client:1.0
docker push ${DOCKER_LOGIN}/wget:1.0