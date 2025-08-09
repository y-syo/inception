#!/bin/sh

if [ -z $DATADIR ]
then
	DATADIR="/var/lib/mysql"
fi

mkdir -p $DATADIR

if [ -z "$( ls -A $DATADIR )" ]
then
	mariadb-install-db --user=mysql --ldata=$DATADIR

	if [ -z $DB_ROOT_PASSWORD ]
	then
		DB_ROOT_PASSWORD="default"
	fi

	if [ -z $DB_PASSWORD ]
	then
		DB_PASSWORD="default"
	fi

	if [ -z $DB_USER ]
	then
		DB_USER="mariadb"
	fi

	if [ -z $DB_DATABASE ]
	then
		DB_DATABASE="default"
	fi

	# envsubst to init.sql to put env in it
	envsubst < /init.sql > /etc/mysql/init.sql
fi

sed -i "s|.*skip-networking.*|skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec $@
