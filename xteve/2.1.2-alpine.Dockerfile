# xTeVe
FROM collelog/buildenv:golang-alpine AS xteve-build


WORKDIR /tmp/xteve
RUN \
	curl -fsSL https://github.com/xteve-project/xTeVe/archive/2.1.2.0120.tar.gz | \
		tar -xz --strip-components=1
RUN go get github.com/koron/go-ssdp
RUN go get github.com/gorilla/websocket
RUN go get github.com/kardianos/osext
RUN mkdir -p /usr/local/xteve
RUN go build -o /usr/local/xteve xteve.go

RUN mkdir -p /build/usr/local/xteve/conf/backup
RUN mkdir -p /build/tmp/xteve
RUN cp --archive --parents --no-dereference /usr/local/xteve /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

EXPOSE 34400

# xTeVe
COPY --from=xteve-build /build /

RUN set -eux && \
	apk add --no-cache \
		ffmpeg \
		tzdata \
		vlc && \
	\
	# cleaning
	rm -rf /var/cache/apk/*

VOLUME /usr/local/xteve/conf
VOLUME /tmp/xteve

WORKDIR /usr/local/xteve

ENTRYPOINT [ "/usr/local/xteve/xteve" ]
CMD [ "-config", "/usr/local/xteve/conf", "-port", "34400" ]
