#!/bin/bash

eval $(minikube docker-env)

docker build -t akalashnykov/mysql-client:1.0 .
