# recfsusb2n
FROM collelog/buildenv:alpine AS recfsusb2n-build

COPY ./patch/epgdatacapbon/Makefile.patch /tmp/
COPY ./patch/epgdatacapbon/decoder.h.patch /tmp/
COPY ./patch/epgdatacapbon/usbdevfile.c.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN apk add --no-cache --update-cache \
	gcc \
	musl

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc) install


WORKDIR /tmp/recfsusb2n
RUN curl -fsSL https://github.com/epgdatacapbon/recfsusb2n/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/recfsusb2n/src
WORKDIR /tmp/recfsusb2n/src
RUN patch < Makefile.patch
RUN patch < decoder.h.patch
RUN patch < usbdevfile.c.patch
RUN make -j $(nproc) B25=1
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recfsusb2n /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recfsusb2n.conf /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recfsusb2n-build /build /build
