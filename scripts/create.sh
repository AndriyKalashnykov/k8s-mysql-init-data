#!/bin/bash

. ./set-env.sh

. ./build-images.sh

## Wait for pod in status Running
function is_pod_running {
    declare namespace=$1 
    declare pod_name=$2

    kubectl get pods --field-selector=status.phase=Running -n $namespace | grep  -w "${pod_name} "
}

function wait_for_pod {
    declare namespace=$1 
    declare pod_name=$2
    declare timeout=$3

    echo "Waiting up to $timeout sec. for pod: $MYSQL_POD_NAME in namespace: $NS_NAME to start Running. Each tick is one second."
    set +x
    
    local time_in_secs=0
    while [[ "$time_in_secs" -lt $timeout ]]; do
        if [[ $(is_pod_running $namespace $pod_name) != "" ]] ; then
            return
        fi
        time_in_secs=$(( time_in_secs+1 ))
        sleep 1
        printf "."
    done
    echo "Failed to obtain pod Running status after $timeout sec."
    exit -1
    set -x
}

kubectl create namespace $NS_NAME

# create PVC
kubectl apply -f ../k8s/mysql-pvc.yaml -n $NS_NAME
kubectl get persistentvolumeclaim mysql-data-disk -n $NS_NAME
kubectl describe persistentvolumeclaim mysql-data-disk -n $NS_NAME

kubectl create -f ../k8s/mysql-client-pod.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-secret.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-cm.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-pod.yaml -n $NS_NAME
kubectl create -f ../k8s/mysql-svc.yaml -n $NS_NAME

. ./list.sh
wait_for_pod $NS_NAME $MYSQL_POD_NAME $KUBECTL_TIMEOUT
. ./list.sh