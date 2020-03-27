# Initializing MySQL Database with data on Kubernetes

`initContainers` can be used to download SQL dump file and restore it to
the database, which is hosted in another container

```yaml
# other config removed for brevity.
spec:
  initContainers:
    - name: fetch
      image: mwendler/wget
      command:
        [
          "wget",
          "--no-check-certificate",
          "https://sample-videos.com/sql/Sample-SQL-File-1000rows.sql",
          "-O",
          "/docker-entrypoint-initdb.d/dump.sql",
        ]
      volumeMounts:
        - mountPath: /docker-entrypoint-initdb.d
          name: dump
# other config removed for brevity.
volumes:
  - name: dump
    emptyDir: {}
  - name: mysql-data
    persistentVolumeClaim:
      claimName: mysql-data-disk
```

#### Pre-requisites

- OS: Mac or Linux
- [Docker](https://docs.docker.com/install/)
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

#### Start Kubernetes cluster

```bash
cd scripts
./start-cluster.sh
```

#### Build Docker image for MySQL client pod

```bash
cd scripts
./build-client-image.sh
```

#### Install

```bash
cd scripts
./create.sh
```

The above command creates a Pod that hosts two containers: the init container
and the application one. Let’s have a look at the interesting aspects of this
definition:

The init container is responsible for downloading the SQL file that contains the
database dump. We use the mwendler/wget image because we only need the wget
command. The destination directory for the downloaded SQL is the directory used
by the MySQL image to execute SQL files (`/docker-entrypoint-initdb.d`). This
behavior is built into the MySQL image that we use in the application container.
The init container mounts `/docker-entrypoint-initdb.d` to an [emptyDir](https://www.alibabacloud.com/blog/kubernetes-volume-basics-emptydir-and-persistentvolume_594834)
volume. Because both containers are hosted on the same Pod, they share the same
volume. So, the database container has access to the SQL file placed on the
emptyDir volume.

The imported table `user_details` is in `your_database` schema.

#### Query table with imported data

Connect to MySQL server pod

```bash
kubectl exec -it mysql -n mysql /bin/bash

$ mysql -u root -D mysql -proot_password
mysql> SELECT * FROM your_database.user_details;
...
1000 rows in set (0.01 sec)
mysql> exit
```

or connect to MySQL client pod

```bash
kubectl exec -it mysql-client -n mysql /bin/ash

$ mysql -h mysql -u your_user -D your_database -pyour_password
mysql> SELECT * FROM your_database.user_details;
...
1000 rows in set (0.01 sec)
mysql> exit
```

#### Cleanup

```bash
cd scripts
./delete.sh
```

#### Stop Kubernetes cluster

```bash
cd scripts
./stop-cluster.sh
```
