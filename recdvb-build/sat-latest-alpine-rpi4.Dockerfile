# recdvb
FROM collelog/buildenv:alpine AS recdvb-build

COPY ./patch/sat/Makefile.in-rpi4.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc) install


WORKDIR /tmp/recdvb
RUN curl -fsSL https://web.archive.org/web/20190917134748/http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.2.tgz | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/recdvb/
RUN patch < Makefile.in-rpi4.patch
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
FROM alpine:latest
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recdvb-build /build /build
