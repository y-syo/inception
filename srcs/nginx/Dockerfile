FROM		scratch
ADD			alpine/alpine-minirootfs-3.21.2-x86_64.tar.gz /

LABEL		version="0.1"
LABEL		maintainer="y-syo"

COPY		nginx/scripts/entrypoint.sh /entrypoint.sh

RUN			set -x
RUN			addgroup -g 101 -S nginx
RUN			adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN			apk add --no-cache nginx openssl tzdata envsubst curl
RUN			ln -sf /dev/stdout /var/log/nginx/access.log
RUN			ln -sf /dev/stderr /var/log/nginx/error.log
RUN			rm -rf /var/cache/apk/*
RUN			mkdir -p /var/www/html
RUN			mkdir -p /etc/nginx/conf.d
RUN			chmod +x /entrypoint.sh

COPY			nginx/conf/nginx.conf /etc/nginx/http.d/nginx.conf
COPY			nginx/health.conf /etc/nginx/http.d/health.conf

ENTRYPOINT		[ "/entrypoint.sh" ]
WORKDIR			/etc/nginx

STOPSIGNAL		SIGQUIT

CMD				[ "nginx", "-g", "daemon off;" ]
HEALTHCHECK		--interval=30s --timeout=10s --retries=3 --start-period=60s --start-interval=5s CMD curl http://127.0.0.1:80/health || exit 1
