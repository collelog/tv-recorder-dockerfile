# recpt1
FROM collelog/recpt1-build:epgdatacapbon-latest-alpine AS recpt1-image


# recdvb
FROM collelog/recdvb-build:latest-alpine AS recdvb-image


# recfsusb2n
FROM collelog/recfsusb2n-build:epgdatacapbon-latest-alpine AS recfsusb2n-image


# epgdump
FROM collelog/epgdump-build:stz2012-latest-alpine AS epgdump-image


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

# recpt1
COPY --from=recpt1-image /build /

# recdvb
COPY --from=recdvb-image /build /

# recfsusb2n
COPY --from=recfsusb2n-image /build /

#epgdump
COPY --from=epgdump-image /build /

RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		ca-certificates \
		curl \
		libxml2-utils \
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
	cd /usr/local/bin && \
	curl -fsSLO https://gist.githubusercontent.com/uru2/479b7da80063e39d1ca2cf467e40e290/raw/c455dcc791c9d3257169d4c85a845f87367a52d7/scan_ch_mirak.sh && \
	chmod 755 scan_ch_mirak.sh && \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/*

WORKDIR /etc/tvchannels-scan

VOLUME /etc/tvchannels-scan
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
