# epgdatacapbon”Årecpt1
FROM collelog/buildenv:alpine AS recpt1-build

COPY ./patch/epgdatacapbon/pt1_dev.h.patch /tmp/
COPY ./patch/epgdatacapbon/recpt1.h.patch /tmp/
COPY ./patch/epgdatacapbon/recpt1core.c.patch /tmp/
COPY ./patch/epgdatacapbon/Makefile.in-rpi3.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN apk add --no-cache --update-cache \
	gcc \
	musl

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install


WORKDIR /tmp/recpt1
RUN curl -fsSL https://github.com/epgdatacapbon/recpt1/tarball/master | \
		tar -xz --strip-components=1
WORKDIR /tmp/recpt1/recpt1
RUN mv /tmp/*.patch /tmp/recpt1/recpt1/
RUN patch < pt1_dev.h.patch
RUN patch < recpt1.h.patch
RUN patch < recpt1core.c.patch
RUN patch < Makefile.in-rpi3.patch
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recpt1 /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.3
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
