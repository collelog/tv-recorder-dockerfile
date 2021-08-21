# arib-b25-stream-test
FROM collelog/buildenv:node16-debian AS build

ENV DEBIAN_FRONTEND=noninteractive

COPY ./patch/Makefile-rpi4.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/arib-b25-stream-test
RUN curl -kfsSL http://registry.npmjs.org/arib-b25-stream-test/-/arib-b25-stream-test-0.2.9.tgz | \
	tar -xz --strip-components=0
WORKDIR /tmp/arib-b25-stream-test/package/src
RUN mv /tmp/*.patch /tmp/arib-b25-stream-test/package/src/
RUN dos2unix Makefile
RUN patch < Makefile-rpi4.patch
WORKDIR /tmp/arib-b25-stream-test/package
RUN npm install . -g --unsafe


WORKDIR /build
RUN cp --archive --parents --dereference /usr/local/bin/arib-b25-stream-test /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/tmp/*


# final image
FROM debian:buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
