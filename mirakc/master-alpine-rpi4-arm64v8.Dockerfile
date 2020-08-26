# mirakc-arib, mirakc
FROM mirakc/mirakc:master-alpine AS mirakc-image
WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/mirakc-arib /build
RUN cp --archive --parents --no-dereference /usr/local/bin/mirakc /build
RUN cp --archive --parents --no-dereference /etc/mirakc /build
RUN cp --archive --parents --no-dereference /etc/mirakurun.openapi.json /build


# libarib25, recpt1
FROM collelog/recpt1-build:latest-alpine-rpi4-arm64v8 AS recpt1-image
RUN mv /build/usr/local/bin/arib-b25-stream /build/usr/local/bin/arib-b25-stream-test


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ENV LD_LIBRARY_PATH=/usr/local/lib64
ENV MIRAKC_CONFIG=/etc/mirakc/config.yml

# mirakc-arib, mirakc
COPY --from=mirakc-image /build /

# libarib25, recpt1
COPY --from=recpt1-image /build /

COPY ./services.sh /usr/local/bin/services.sh

RUN set -eux && \
	apk upgrade --update && \
	apk add --no-cache \
		ca-certificates \
		ccid \
		curl \
		libstdc++ \
		pcsc-lite \
		pcsc-lite-libs \
		socat \
		tzdata && \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/* && \
	\
	chmod 755 /usr/local/bin/services.sh

EXPOSE 40772
VOLUME /var/lib/mirakc/epg
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
