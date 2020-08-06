# FFmpeg
FROM collelog/ffmpeg:4.3.1-alpine-arm64v8 AS ffmpeg-image


# EPGStation
FROM collelog/buildenv:node12-alpine-jst AS epgstation-build

WORKDIR /usr/local/EPGStation
RUN curl -fsSL https://github.com/l3tnun/EPGStation/archive/v1.7.0.tar.gz | \
		tar -xz --strip-components=1
RUN npm install --nosave --python=/usr/bin/python3
RUN npm run build

RUN mkdir -p /build
RUN cp --archive --parents --no-dereference /usr/local/EPGStation /build
RUN cp --archive --parents --no-dereference /etc/localtime /build
RUN cp --archive --parents --no-dereference /etc/timezone /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM node:12-alpine
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

EXPOSE 8888
EXPOSE 8889

ENV LD_LIBRARY_PATH=/opt/vc/lib:/usr/local/lib64:/usr/local/lib:/usr/lib:/lib

# FFmpeg
COPY --from=ffmpeg-image /build /

# EPGStation
COPY --from=epgstation-build /build /

RUN set -eux && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
	echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
	apk upgrade --update && \
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
