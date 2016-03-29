#!/bin/bash
set -eo pipefail


chown -R mysql:mysql "$DATADIR"
if [ ! -d "$DATADIR/mysql" ]; then
 if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
   MYSQL_ROOT_PASSWORD=root
 fi
# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
 echo "mysql-server-5.6 mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
 echo "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
 dpkg-reconfigure -f noninteractive  $MYSQL_SERVER
fi



if [ "$CREATE_DATABASE" = "true" ]; then
# echo "SQL_STATEMENT" |  mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 mysqld_safe & sleep 10s
 echo "CREATE DATABASE ${MYSQL_DBNAME};" | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 echo "CREATE USER ${MYSQL_DBUSER}@'%' IDENTIFIED BY '${MYSQL_DBPASSWORD}';" | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 echo "GRANT ALL ON ${MYSQL_DBNAME}.* TO ${MYSQL_DBUSER}@'%' WITH GRANT OPTION;" | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 killall mysqld_safe & sleep 3s
 killall -9 mysqld_safe & sleep 2s
fi



exec mysqld_safe


