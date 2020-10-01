# recdvb
FROM collelog/buildenv:alpine AS recdvb-build

COPY ./patch/Makefile.in.patch /tmp/

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


WORKDIR /tmp/recdvb
RUN curl -fsSL http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.2.tgz | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/recdvb/
RUN patch < Makefile.in.patch
RUN sed -i -e s/msgbuf/_msgbuf/ recpt1core.h
RUN sed -i '1i#include <sys/types.h>' recpt1.h
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recdvb /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recdvb-build /build /build
