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


exec mysqld_safe


