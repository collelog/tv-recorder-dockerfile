# mirakc-arib, mirakc
FROM mirakc/mirakc:debian AS mirakc-image
WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/mirakc-arib /build
RUN cp --archive --parents --no-dereference /usr/local/bin/mirakc /build
RUN cp --archive --parents --no-dereference /etc/mirakc /build


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
FROM node:18-bookworm-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml

COPY ./services.sh /usr/local/bin/services.sh

# mirakc-arib, mirakc
COPY --from=mirakc-image /build /

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
		jq \
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
	# cleaning
	apt-get clean && \
	rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
	\
	chmod 755 /usr/local/bin/services.sh

EXPOSE 40772
VOLUME /var/lib/mirakc/epg
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
