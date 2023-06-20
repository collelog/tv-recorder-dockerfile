# mirakurun-build
FROM collelog/buildenv:node18-debian-bullseye AS mirakurun-build

ENV DOCKER="YES"
WORKDIR /tmp
RUN curl -kfsSLo mirakurun.zip http://github.com/Chinachu/Mirakurun/archive/refs/heads/master.zip
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
FROM collelog/libarib25-build:epgdatacapbon-latest-debian-amd64 AS libarib25-image


# recpt1
FROM collelog/recpt1-build:stz2012-latest-debian-amd64 AS recpt1-image


# recdvb
FROM collelog/recdvb-build:kaikoma-soft-latest-debian-amd64 AS recdvb-image


# recfsusb2n
FROM collelog/recfsusb2n-build:epgdatacapbon-latest-debian-amd64 AS recfsusb2n-image


# arib-b25-stream-test
FROM collelog/arib-b25-stream-test-build:latest-debian-amd64 AS arib-b25-stream-test-image


# final image
FROM node:18-bullseye-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

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
	apt-get update -qq && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		dvb-tools \
		libboost-filesystem1.74.0 \
		libboost-thread1.74.0 \
		libccid \
		pcscd \
		pcsc-tools \
		socat && \
	\
	mkdir /etc/dvbv5 && \
	cd /etc/dvbv5 && \
	curl -kfsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbs.conf && \
	curl -kfsSLO https://raw.githubusercontent.com/Chinachu/dvbconf-for-isdb/master/conf/dvbv5_channels_isdbt.conf && \
	\
	mkdir -p /usr/local/mirakurun/opt/bin/ && \
	cp /usr/local/bin/recpt1 /usr/local/mirakurun/opt/bin/  && \
	\
	# cleaning
	apt-get clean && \
	rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 40772
EXPOSE 9229
ENTRYPOINT []
CMD ["/app/docker/container-init.sh"]
