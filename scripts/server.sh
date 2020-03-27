#!/bin/bash

kubectl exec -it mysql -n mysql /bin/bash

# connect to MySQL and query the imported table

# mysql -u root -D mysql -proot_password
# SELECT * FROM your_database.user_details;

# SELECT user, plugin FROM user WHERE user="your_user";
# SELECT table_name FROM information_schema.tables;
# SELECT table_name FROM information_schema.tables WHERE TABLE_SCHEMA = 'your_database';
# select schema_name as database_name from information_schema.schemata order by schema_name;