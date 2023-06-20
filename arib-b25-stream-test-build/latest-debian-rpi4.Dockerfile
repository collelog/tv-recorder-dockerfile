# arib-b25-stream-test
FROM collelog/buildenv:node16-debian-bullseye AS build

ENV DEBIAN_FRONTEND=noninteractive

COPY ./patch/Makefile-rpi4.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev \
	pkg-config


WORKDIR /tmp/arib-b25-stream-test
RUN wget --no-check-certificate https://registry.npmjs.org/arib-b25-stream-test/-/arib-b25-stream-test-0.2.9.tgz
RUN tar -xz --strip-components=0 -f arib-b25-stream-test-0.2.9.tgz
WORKDIR /tmp/arib-b25-stream-test/package/src
RUN mv /tmp/*.patch /tmp/arib-b25-stream-test/package/src/
RUN dos2unix Makefile
RUN patch < Makefile-rpi4.patch
WORKDIR /tmp/arib-b25-stream-test/package
RUN npm install . -g --unsafe


WORKDIR /build
RUN cp --archive --parents --dereference /usr/local/bin/arib-b25-stream-test /build

RUN npm cache verify
RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* ~/.npm


# final image
FROM debian:bullseye-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
