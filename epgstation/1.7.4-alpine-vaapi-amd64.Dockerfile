# FFmpeg
FROM collelog/ffmpeg:4.3.1-alpine-vaapi-amd64 AS ffmpeg-image


# sqlite3-regexp
FROM collelog/sqlite3-regexp-build:3.31.1-alpine-amd64 AS sqlite3-regexp-image


# EPGStation
FROM collelog/epgstation-build:1.7.4-alpine AS epgstation-image


# final image
FROM node:14.15.4-alpine3.123.12
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/lib64:/lib64:/usr/local/lib:/usr/lib:/lib

# FFmpeg
COPY --from=ffmpeg-image /build /

# EPGStation
COPY --from=epgstation-image /build /

# sqlite3-regexp
COPY --from=sqlite3-regexp-image /build/usr/lib/sqlite3.31.1/regexp.so /opt/epgstation

RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		curl \
		tzdata && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
	apk add --no-cache --update-cache \
		musl && \
	\
	# cleaning
	npm cache verify && \
	rm -rf /tmp/* ~/.npm /var/cache/apk/*

WORKDIR /opt/epgstation

EXPOSE 8888
EXPOSE 8889
VOLUME /opt/epgstation/config
VOLUME /opt/epgstation/data
VOLUME /opt/epgstation/logs
VOLUME /opt/epgstation/recorded
VOLUME /opt/epgstation/thumbnail
ENTRYPOINT ["npm"]
CMD ["start"]
