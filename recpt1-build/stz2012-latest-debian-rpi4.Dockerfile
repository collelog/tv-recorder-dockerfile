# stz2012 recpt1
FROM collelog/buildenv:debian AS recpt1-build

COPY ./patch/stz2012/pt1_dev.h.patch /tmp/
COPY ./patch/stz2012/recpt1.h.patch /tmp/
COPY ./patch/stz2012/recpt1core.c.patch /tmp/
COPY ./patch/stz2012/Makefile.in-rpi4.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/libarib25
RUN curl -kfsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install


WORKDIR /tmp/recpt1
RUN curl -kfsSL https://github.com/stz2012/recpt1/tarball/master | \
		tar -xz --strip-components=1
WORKDIR /tmp/recpt1/recpt1
RUN mv /tmp/*.patch /tmp/recpt1/recpt1/
RUN patch < pt1_dev.h.patch
RUN patch < recpt1core.c.patch
RUN patch < Makefile.in-rpi4.patch
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
