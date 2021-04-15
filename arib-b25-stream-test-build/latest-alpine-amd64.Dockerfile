# arib-b25-stream-test
FROM collelog/buildenv:node12-alpine AS build

COPY ./patch/Makefile-amd64.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

WORKDIR /tmp/arib-b25-stream-test
RUN curl -fsSL http://registry.npmjs.org/arib-b25-stream-test/-/arib-b25-stream-test-0.2.9.tgz | \
	tar -xz --strip-components=0
WORKDIR /tmp/arib-b25-stream-test/package/src
RUN mv /tmp/*.patch /tmp/arib-b25-stream-test/package/src/
RUN dos2unix Makefile
RUN patch < Makefile-amd64.patch
WORKDIR /tmp/arib-b25-stream-test/package
RUN npm install . -g --unsafe


WORKDIR /build
RUN cp --archive --parents --dereference /usr/local/bin/arib-b25-stream-test /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
