# Initializing MySQL Database with data on Kubernetes

`initContainers` can be used to download SQL dump file and restore it to
the database, which is hosted in another container

```yaml
# other config removed for brevity.

spec:
  initContainers:
    - name: fetch
      image: akalashnykov/wget:1.0
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
    - name: mysql
  containers:
    - name: mysql
      image: mysql:8.0.19
      imagePullPolicy: IfNotPresent
      ports:
        - containerPort: 3306
          name: mysql  
volumes:
  - name: dump
    emptyDir: {}

# other config removed for brevity.    
```

#### MySQL configuration

- Logins - `./k8s/mysql-cm.yaml`

  ```yaml
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: mysql-config
    labels:
      app: mysql
  data:
    MYSQL_DATABASE: "your_database"
    MYSQL_USER: "your_user"
    default_auth: |
      [mysqld]
      default_authentication_plugin=mysql_native_password
  ```

- Passwords - `./k8s/mysql-secret.yaml`

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: mysql-secrets
  type: Opaque
  data:
    MYSQL_PASSWORD: eW91cl9wYXNzd29yZA==
    MYSQL_ROOT_PASSWORD: cm9vdF9wYXNzd29yZA==
  ```

  Generate passwords
  ```bash
  cd ./scripts
  ./encode-pwd.sh
  ```

#### Pre-requisites

- OS: Mac or Linux
- [Docker](https://docs.docker.com/install/)
- [Virtualbox](https://www.virtualbox.org/manual/ch02.html)
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
./build-images.sh
```

#### Install

```bash
cd scripts
eval $(minikube docker-env)
./create.sh
./list.sh
```

The above command creates a Pod that hosts two containers: the init container - `fetch`
and the application container - `mysql`.

The init container is responsible for downloading the SQL file that contains the
database dump. We use the `akalahnykov/wget:1.0` image because we only need the `wget`
command. The destination directory for the downloaded SQL is the directory used
by the MySQL image to execute SQL files (`/docker-entrypoint-initdb.d`). This
behavior is built into the MySQL image that we use in the application container.
The init container mounts `/docker-entrypoint-initdb.d` to an [emptyDir](https://www.alibabacloud.com/blog/kubernetes-volume-basics-emptydir-and-persistentvolume_594834)
volume. Because both containers are hosted on the same Pod, they share the same
volume and MySQL database container has access to the SQL dump file placed on the
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

or connect to MySQL from mysql-client pod

```bash
kubectl exec -it mysql-client -n mysql /bin/ash

$ mysql -h mysql -u your_user -D your_database -pyour_password
MySQL [your_database]> SELECT * FROM your_database.user_details;
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
