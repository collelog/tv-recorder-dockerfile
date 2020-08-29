# FFmpeg
FROM collelog/ffmpeg:4.3.1-alpine-arm32v6 AS ffmpeg-image


# EPGStation
FROM collelog/epgstation-build:1.7.3-alpine AS epgstation-build


# final image
FROM node:14-alpine
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib

# FFmpeg
COPY --from=ffmpeg-image /build /

# EPGStation
COPY --from=epgstation-build /build /

RUN set -eux && \
	apk upgrade --update && \
	apk add --no-cache --update \
		curl \
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
