# recpt1
FROM collelog/buildenv:alpine AS recpt1-build

COPY ./patch/original/decoder.h.patch /tmp/
COPY ./patch/original/pt1_dev.h.patch /tmp/
COPY ./patch/original/recpt1.h.patch /tmp/
COPY ./patch/original/recpt1core.h.patch /tmp/
COPY ./patch/original/tssplitter_lite.h.patch /tmp/
COPY ./patch/original/tssplitter_lite.c.patch /tmp/
COPY ./patch/original/Makefile.in.patch /tmp/


RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make install


WORKDIR /tmp/recpt1
RUN curl -fsSL http://hg.honeyplanet.jp/pt1/archive/tip.tar.bz2 | \
		tar -xj --strip-components=1
WORKDIR /tmp/recpt1/recpt1
RUN mv /tmp/*.patch /tmp/recpt1/recpt1/
RUN patch < decoder.h.patch
RUN patch < pt1_dev.h.patch
RUN patch < recpt1.h.patch
RUN patch < recpt1core.h.patch
RUN patch < tssplitter_lite.h.patch
RUN patch < tssplitter_lite.c.patch
RUN patch < Makefile.in.patch
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recpt1 /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
