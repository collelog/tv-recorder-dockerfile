FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY ./scripts/run.sh /scripts/run.sh

RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		pwgen \
		tzdata && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		mariadb=10.5.8-r0 \
		mariadb-client=10.5.8-r0 \
		mariadb-server-utils=10.5.8-r0 && \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/* && \
	\
	mkdir /docker-entrypoint-initdb.d && \
	mkdir /scripts/pre-exec.d && \
	mkdir /scripts/pre-init.d && \
	chmod -R 755 /scripts

WORKDIR /var/lib/mysql

EXPOSE 3306
VOLUME /var/lib/mysql
ENTRYPOINT ["/scripts/run.sh"]
CMD []
