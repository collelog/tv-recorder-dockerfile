# arib-b25-stream-test
FROM collelog/arib-b25-stream-test-build:latest-alpine-rpi4-32 AS arib-b25-stream-test-image


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

# arib-b25-stream-test
COPY --from=arib-b25-stream-test-image /build /

COPY ./services.sh /usr/local/bin/

RUN set -eux && \
	apk upgrade --no-cache --update-cache && \
	apk add --no-cache --update-cache \
		ccid \
		libstdc++ \
		pcsc-lite \
		pcsc-lite-libs \
		socat \
		tzdata && \
	\
	mv /usr/local/bin/arib-b25-stream-test /usr/local/bin/b25 && \
	\
	# cleaning
	rm -rf /tmp/* /var/cache/apk/* && \
	\
	chmod 755 /usr/local/bin/services.sh

EXPOSE 40773
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
