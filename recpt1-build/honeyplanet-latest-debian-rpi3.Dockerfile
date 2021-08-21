# recpt1
FROM collelog/buildenv:debian AS recpt1-build

COPY ./patch/honeyplanet/decoder.h.patch /tmp/
COPY ./patch/honeyplanet/pt1_dev.h.patch /tmp/
COPY ./patch/honeyplanet/recpt1.h.patch /tmp/
COPY ./patch/honeyplanet/recpt1core.h.patch /tmp/
COPY ./patch/honeyplanet/tssplitter_lite.h.patch /tmp/
COPY ./patch/honeyplanet/tssplitter_lite.c.patch /tmp/
COPY ./patch/honeyplanet/Makefile.in-rpi3.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install


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
RUN patch < Makefile.in-rpi3.patch
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recpt1 /build

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


# final image
FROM debian:buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
