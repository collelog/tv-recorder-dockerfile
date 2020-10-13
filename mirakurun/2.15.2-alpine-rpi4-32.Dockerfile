# mirakurun-build
FROM collelog/buildenv:node12-alpine AS mirakurun-build

ENV DOCKER="YES"

RUN npm install mirakurun@2.15.2 -g --unsafe-perm --production
RUN cp --archive --parents --no-dereference /usr/local/lib/node_modules/mirakurun /build
RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# libarib25 
FROM collelog/libarib25-build:latest-alpine-rpi4-32 AS libarib25-image


# recpt1
FROM collelog/recpt1-build:latest-alpine-rpi4-32 AS recpt1-image


# recdvb
FROM collelog/recdvb-build:latest-alpine-rpi4-32 AS recdvb-image


# recfsusb2n
FROM collelog/recfsusb2n-build:epgdatacapbon-latest-alpine-rpi4-32 AS recfsusb2n-image


# arib-b25-stream-test
FROM collelog/arib-b25-stream-test-build:latest-alpine-rpi4-32 AS arib-b25-stream-test-image


# final image
FROM node:12-alpine
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib64

COPY ./services.sh /usr/local/bin/

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
		ca-certificates \
		ccid \
		curl \
		libstdc++ \
		pcsc-lite \
		pcsc-lite-libs \
		socat \
		tzdata && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		v4l-utils-dvbv5 && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		musl && \
	\
	mkdir /etc/dvbv5 && \
	cd /etc/dvbv5 && \
	curl -fsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbs.conf && \
	curl -fsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbt.conf && \
	\
	# cleaning
	npm cache verify && \
	rm -rf /tmp/* ~/.npm /var/cache/apk/* && \
	\
	chmod 755 /usr/local/bin/services.sh

WORKDIR /usr/local/lib/node_modules/mirakurun

EXPOSE 40772
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
