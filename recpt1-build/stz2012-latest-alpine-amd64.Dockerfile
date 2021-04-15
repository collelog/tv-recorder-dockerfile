# stz2012”Årecpt1
FROM collelog/buildenv:alpine AS recpt1-build

COPY ./patch/stz2012/pt1_dev.h.patch /tmp/
COPY ./patch/stz2012/recpt1.h.patch /tmp/
COPY ./patch/stz2012/recpt1core.c.patch /tmp/
COPY ./patch/stz2012/Makefile.in-amd64.patch /tmp/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install


WORKDIR /tmp/recpt1
RUN curl -fsSL https://github.com/stz2012/recpt1/tarball/master | \
		tar -xz --strip-components=1
WORKDIR /tmp/recpt1/recpt1
RUN mv /tmp/*.patch /tmp/recpt1/recpt1/
RUN patch < pt1_dev.h.patch
RUN patch < recpt1.h.patch
RUN patch < recpt1core.c.patch
RUN patch < Makefile.in-amd64.patch
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recpt1 /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
