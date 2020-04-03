#!/bin/bash

set +x

. ./set-env.sh

kubectl get pod $MYSQL_POD_NAME $MYSQL_CLIENT_POD_NAME -n $NS_NAME