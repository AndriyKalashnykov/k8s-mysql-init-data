#!/bin/bash

kubectl exec -it mysql-client -n mysql /bin/ash

# connect to MySQL and query the imported table

# mysql -h mysql -u your_user -D your_database -pyour_password
# SELECT * FROM your_database.user_details;

