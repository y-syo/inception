FROM		scratch
ADD			alpine/alpine-minirootfs-3.21.2-x86_64.tar.gz /

LABEL		version="0.1"
LABEL		maintainer="y-syo"

COPY		mariadb/scripts/entrypoint.sh /entrypoint.sh
COPY		mariadb/scripts/init.sql /init.sql

RUN			apk --no-cache add mariadb tzdata mariadb-client gettext
RUN			chmod +x /entrypoint.sh
RUN			mkdir -p /etc/mysql/conf.d /etc/mysql/mariadb.conf.d/ /run/mariadb /run/mysqld
RUN			chmod ugo+rwx,o+t /run/mariadb
RUN			chown -R mysql:mysql /var/lib/mysql /run/mariadb /run/mysqld

ENV			LANG=C.UTF-8

COPY		--chmod=0644 mariadb/conf/docker.cnf /etc/my.cnf.d/mariadb-server.cnf

VOLUME		/var/lib/mysql

ENTRYPOINT	[ "/entrypoint.sh" ]
WORKDIR		/var/lib/mysql

EXPOSE		3306
CMD			[ "mariadbd", "--user=mysql", "--skip-networking=0" ]
