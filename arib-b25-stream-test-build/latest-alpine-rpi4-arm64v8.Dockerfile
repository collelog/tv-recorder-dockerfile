# arib-b25-stream-test
FROM collelog/buildenv:node12-alpine AS build

COPY ./patch/Makefile-rpi4-arm64v8.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN apk add --no-cache --update-cache \
	gcc=10.2.0-r5 \
	musl=1.2.1-r1

WORKDIR /tmp/arib-b25-stream-test
RUN curl -fsSL http://registry.npmjs.org/arib-b25-stream-test/-/arib-b25-stream-test-0.2.9.tgz | \
	tar -xz --strip-components=0
WORKDIR /tmp/arib-b25-stream-test/package/src
RUN mv /tmp/*.patch /tmp/arib-b25-stream-test/package/src/
RUN dos2unix Makefile
RUN patch < Makefile-rpi4-arm64v8.patch
WORKDIR /tmp/arib-b25-stream-test/package
RUN npm install . -g --unsafe


WORKDIR /build
RUN cp --archive --parents --dereference /usr/local/bin/arib-b25-stream-test /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
