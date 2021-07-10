# mirakurun-build
FROM collelog/buildenv:node14-alpine AS mirakurun-build

ENV DOCKER="YES"
WORKDIR /tmp
RUN curl -fsSLo mirakurun.zip https://github.com/Chinachu/Mirakurun/archive/refs/heads/master.zip
RUN unzip mirakurun.zip
RUN chmod -R 755 ./Mirakurun-master
RUN mv ./Mirakurun-master /app
WORKDIR /app
RUN npm install
RUN npm run build
RUN npm install -g --unsafe-perm --production
RUN mkdir -p /build
RUN cp --archive --recursive --dereference /usr/local/lib/node_modules/mirakurun /build/app
RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# libarib25 
FROM collelog/libarib25-build:epgdatacapbon-latest-alpine-amd64 AS libarib25-image


# recpt1
FROM collelog/recpt1-build:stz2012-latest-alpine-amd64 AS recpt1-image


# recdvb
FROM collelog/recdvb-build:latest-alpine-amd64 AS recdvb-image


# recfsusb2n
FROM collelog/recfsusb2n-build:epgdatacapbon-latest-alpine-amd64 AS recfsusb2n-image


# arib-b25-stream-test
FROM collelog/arib-b25-stream-test-build:latest-alpine-amd64 AS arib-b25-stream-test-image


# final image
FROM node:14-alpine3.13
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib

# mirakurun
COPY --from=mirakurun-build /build /

# libarib25
COPY --from=libarib25-image /build /

# recpt1
COPY --from=recpt1-image /build /

# recdvb
COPY --from=recdvb-image /build /

# recfsusb2n
COPY --from=recfsusb2n-image /build /

# arib-b25-stream-test
COPY --from=arib-b25-stream-test-image /build /


RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		bash \
		boost \
		ca-certificates \
		ccid \
		curl \
		libstdc++ \
		openrc \
		pcsc-lite \
		pcsc-lite-libs \
		socat \
		tzdata && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		v4l-utils-dvbv5 && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		pcsc-tools && \
	\
	mkdir /run/openrc && \
	touch /run/openrc/softlevel && \
	\
	sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
	echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
	sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
	sed -i '/tty/d' /etc/inittab && \
	sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \
	sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh && \
	sed -i -e 's/cgroup_add_service$/# cgroup_add_service/g' /lib/rc/sh/openrc-run.sh && \
	\
	mkdir /etc/dvbv5 && \
	cd /etc/dvbv5 && \
	curl -fsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbs.conf && \
	curl -fsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbt.conf && \
	\
	mkdir -p /usr/local/mirakurun/opt/bin/ && \
	cp /usr/local/bin/recpt1 /usr/local/mirakurun/opt/bin/  && \
	\
	sed -i -e '3i if [ -e "/etc/init.d/pcscd" ]; then /etc/init.d/pcscd stop; sleep 1; fi' /app/docker/container-init.sh && \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app

EXPOSE 40772
EXPOSE 9229
ENTRYPOINT []
CMD ["/app/docker/container-init.sh"]
