#!/bin/bash

set +x

. ./set-env.sh

. ./build-images.sh

if [ -z "${IS_MINIKUBE}" ] 
then
    echo "Set IS_MINIKUBE in ./set-env.sh"
    exit 1
fi

if [ ${IS_MINIKUBE} -ne 1 ] ; then
    . ./push-images.sh
fi

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
echo "Waiting up to ${KUBECTL_TIMEOUT} sec. for pod: $MYSQL_POD_NAME ..."
kubectl -n $NS_NAME wait --for=condition=Ready --timeout=${KUBECTL_TIMEOUT}s pod/$MYSQL_POD_NAME
. ./list.sh

kubectl logs $MYSQL_POD_NAME -n $NS_NAME -c fetch # Inspect the first init container
kubectl logs $MYSQL_POD_NAME -n $NS_NAME -c mysql # Inspect MySQL container
