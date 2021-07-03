# FFmpeg
FROM collelog/ffmpeg:4.4-alpine-arm32v6 AS ffmpeg-image


# sqlite3-regexp
FROM collelog/sqlite3-regexp-build:3.31.1-alpine AS sqlite3-regexp-image


# sqlite-pcre2
FROM collelog/sqlite-pcre2-build:latest-alpine AS sqlite-pcre2-image


# EPGStation
FROM collelog/epgstation-build:2.5.1-alpine AS epgstation-image


# final image
FROM node:14.16.1-alpine3.13
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# FFmpeg
COPY --from=ffmpeg-image /build /

# EPGStation
COPY --from=epgstation-image /build /

# sqlite3-regexp
COPY --from=sqlite3-regexp-image /build/usr/lib/sqlite3.31.1/regexp.so /opt/epgstation

# sqlite-pcre2
COPY --from=sqlite-pcre2-image /build/usr/lib/sqlite3/libsqlite_pcre.so /opt/epgstation

RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		curl \
		pcre2 \
		tzdata && \
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
