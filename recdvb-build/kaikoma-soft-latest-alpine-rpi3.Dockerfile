# recdvb
FROM collelog/buildenv:alpine AS recdvb-build

COPY ./patch/kaikoma-soft/Makefile.in-rpi3.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc) install


WORKDIR /tmp/recdvb
RUN curl -fsSL https://github.com/kaikoma-soft/recdvb/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/recdvb/
RUN patch < Makefile.in-rpi3.patch
RUN sed -i -e s/msgbuf/_msgbuf/ recpt1core.h
RUN sed -i '1i#include <sys/types.h>' recpt1.h
RUN sed -i '1i#include <sys/types.h>' tssplitter_lite.h
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recdvb /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recdvb-build /build /build
