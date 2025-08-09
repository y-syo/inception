#!/bin/sh

if [ -n $DATADIR ]
then
	DATADIR="/var/lib/mysql"
fi

mkdir -p $DATADIR

if [ -z "$( ls -A $DATADIR )" ]
then
	mariadb-install-db --user=mysql --ldata=$DATADIR

	if [ -n $MYSQL_ROOT_PASSWORD ]
	then
		MYSQL_ROOT_PASSWORD="default"
	fi

	if [ -n $MYSQL_PASSWORD ]
	then
		MYSQL_PASSWORD="default"
	fi

	if [ -n $MYSQL_USER ]
	then
		MYSQL_USER="mariadb"
	fi

	if [ -n $MYSQL_DATABASE ]
	then
		MYSQL_DATABASE="default"
	fi

# envsubst to init.sql to put env in it
mariadb --user=root -e $(envsubst < /init.sql)
fi

exec $@
