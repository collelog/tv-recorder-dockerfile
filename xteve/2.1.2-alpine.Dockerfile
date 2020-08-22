# xTeVe
FROM collelog/buildenv:golang-alpine AS xteve-build

WORKDIR /tmp/xteve
RUN \
	curl -fsSL https://github.com/xteve-project/xTeVe/archive/2.1.2.0120.tar.gz | \
		tar -xz --strip-components=1
RUN go get github.com/koron/go-ssdp
RUN go get github.com/gorilla/websocket
RUN go get github.com/kardianos/osext
RUN mkdir /opt/xteve
RUN go build -o /opt/xteve xteve.go

WORKDIR /build
RUN mkdir -p /build/etc/opt/xteve/backup
RUN mkdir -p /build/tmp/xteve
RUN cp --archive --parents --no-dereference /opt/xteve /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

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

WORKDIR /opt/xteve

EXPOSE 34400
VOLUME /etc/opt/xteve
VOLUME /tmp/xteve
ENTRYPOINT ["/opt/xteve/xteve"]
CMD ["-config", "/etc/opt/xteve", "-port", "34400"]
