# FFmpeg
FROM collelog/ffmpeg:4.3.1-alpine-rpi-arm32v6 AS ffmpeg-image


# EPGStation
FROM collelog/epgstation-build:1.6.8-alpine AS epgstation-build


# final image
FROM node:12-alpine
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

EXPOSE 8888
EXPOSE 8889

ENV LD_LIBRARY_PATH=/opt/vc/lib:/usr/local/lib:/usr/lib:/lib

# FFmpeg
COPY --from=ffmpeg-image /build /

# EPGStation
COPY --from=epgstation-build /build /

RUN set -eux && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
	apk upgrade --update && \
	apk add --no-cache --update \
		raspberrypi-libs && \
	\
	# Compatible with Old Version config.json
	mkdir -p /usr/local/ffmpeg/bin && \
	ln -s /usr/local/bin/ffmpeg /usr/local/ffmpeg/bin/ffmpeg && \
	ln -s /usr/local/bin/ffprobe /usr/local/ffmpeg/bin/ffprobe && \
	\
	# cleaning
	npm cache verify && \
	rm -rf /tmp/* ~/.npm /var/cache/apk/*

WORKDIR /usr/local/EPGStation

ENTRYPOINT npm start
