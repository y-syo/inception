FROM		scratch
ADD			alpine/alpine-minirootfs-3.21.2-x86_64.tar.gz /

LABEL		version="0.1"
LABEL		maintainer="y-syo"

COPY		wordpress/scripts/entrypoint.sh /entrypoint.sh

RUN			set -x
RUN			adduser -u 82 -D -S -G www-data www-data
RUN			apk add --no-cache curl tzdata fcgi \
				php84-phar php84-xml php84-curl php84-zip \
				php84-intl php84-mbstring php84-iconv \
				php84 php84-mysqli php84-fpm php84-json \
				php84-zlib php84-session php84-dom \
				php84-xmlreader php84-pdo php84-gd \
				php84-opcache php84-ctype php84-tokenizer mariadb-client
RUN			curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN			chmod +x wp-cli.phar
RUN			mv wp-cli.phar /usr/local/bin/wp
RUN			chmod +x /entrypoint.sh
RUN			rm -Rf /build

COPY		wordpress/www-docker.conf /etc/php84/php-fpm.d/www.conf
RUN			cp /usr/bin/php84 /usr/bin/php

VOLUME		/var/www/wordpress

WORKDIR		/var/www

RUN			version='6.7.2' \
			&& curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$version.tar.gz" \
			&& apk del curl \
			&& rm -rf /var/cache/apk/* \
			&& tar -xzvf wordpress.tar.gz \
			&& rm wordpress.tar.gz \
			&& chown -R www-data:www-data /var/www/wordpress \
			&& mkdir wp-content \
			&& for dir in /var/www/wp-content/*/ cache; do \
				dir="$(basename "${dir%/}")"; \
				mkdir "wp-content/$dir"; \
			done \
			&& chown -R www-data:www-data /var/www/wordpress/wp-content \
			&& chmod -R 1777 /var/www/wordpress/wp-content

ENTRYPOINT	[ "/entrypoint.sh" ]
WORKDIR		/var/www/wordpress
STOPSIGNAL	SIGQUIT

EXPOSE		9000
CMD			[ "php-fpm84", "-F" ]
HEALTHCHECK	--interval=30s --timeout=10s --retries=3 --start-period=60s --start-interval=5s  CMD cgi-fcgi -bind -connect 127.0.0.1:${PHP_PORT:-9000} || exit 1
