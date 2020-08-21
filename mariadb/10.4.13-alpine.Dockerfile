FROM alpine:3.12
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

EXPOSE 3306

COPY ./scripts/run.sh /scripts/run.sh

RUN set -eux && \
	apk upgrade --update && \
	apk add --no-cache \
		mariadb=10.4.13-r0 \
		mariadb-client=10.4.13-r0 \
		mariadb-server-utils=10.4.13-r0 \
		pwgen \
	&& \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/* && \
	\
	mkdir /docker-entrypoint-initdb.d && \
	mkdir /scripts/pre-exec.d && \
	mkdir /scripts/pre-init.d && \
	chmod -R 755 /scripts

VOLUME /var/lib/mysql

WORKDIR /var/lib/mysql

ENTRYPOINT /scripts/run.sh
