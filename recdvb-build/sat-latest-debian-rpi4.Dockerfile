# recdvb
FROM collelog/buildenv:debian-bookworm AS recdvb-build

ENV DEBIAN_FRONTEND=noninteractive

COPY ./patch/sat/Makefile.in-rpi4.patch /tmp/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc) install


WORKDIR /tmp/recdvb
RUN curl -kfsSL --retry 10 --retry-delay 1 --retry-connrefused https://web.archive.org/web/20190917134748/http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.2.tgz https://web.archive.org/web/20190917134748/http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.2.tgz | \
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

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


# final image
FROM debian:bookworm-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recdvb-build /build /build
