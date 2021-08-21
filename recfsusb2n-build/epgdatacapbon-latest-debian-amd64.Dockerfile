# recfsusb2n
FROM collelog/buildenv:debian AS recfsusb2n-build

ENV DEBIAN_FRONTEND=noninteractive

COPY ./patch/epgdatacapbon/debian/Makefile-amd64.patch /tmp/

COPY ./patch/epgdatacapbon/decoder.h.patch /tmp/
COPY ./patch/epgdatacapbon/usbdevfile.c.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/libarib25
RUN curl -kfsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc) install


WORKDIR /tmp/recfsusb2n
RUN curl -fsSL https://github.com/epgdatacapbon/recfsusb2n/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/recfsusb2n/src
WORKDIR /tmp/recfsusb2n/src
RUN patch < Makefile-amd64.patch
RUN patch < decoder.h.patch
RUN patch < usbdevfile.c.patch
RUN make -j $(nproc) B25=1
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recfsusb2n /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recfsusb2n.conf /build

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


# final image
FROM debian:buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recfsusb2n-build /build /build
