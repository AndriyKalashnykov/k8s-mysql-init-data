FROM gliderlabs/alpine:3.9

# libmysqlclient uses caching_sha2_password as the default choice while
# connecting to MySQL server, since it's not availabe to download it 
# we can get it as part of mariadb-dev

RUN apk-install mariadb-dev mariadb-client mariadb-static

RUN ls -al /usr/lib/mariadb/plugin/

ENTRYPOINT ["mysql"]