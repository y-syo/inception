# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    entrypoint.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mmoussou <mmoussou@student.42angouleme.fr  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/27 15:48:54 by mmoussou          #+#    #+#              #
#    Updated: 2025/04/27 17:12:28 by mmoussou         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

if [ -n $DATADIR ]
then
	DATADIR="/var/lib/mysql"
fi
if [ -f $DATADIR ]
then
	mkdir -p $DATADIR
fi

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
