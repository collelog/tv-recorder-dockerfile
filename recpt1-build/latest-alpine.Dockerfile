# libarib25, recpt1
FROM collelog/buildenv:alpine-jst AS recpt1-build

RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake .
RUN make install

WORKDIR /tmp/recpt1
RUN curl -fsSL https://github.com/stz2012/recpt1/tarball/master | \
		tar -xz --strip-components=1
RUN cd ./recpt1
RUN ./autogen.sh
RUN ./configure --prefix=/usr/local --enable-b25
RUN make -j $(nproc)
RUN make install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/lib64/libarib25.* /build || true
RUN cp --archive --parents --no-dereference /usr/local/lib64/pkgconfig/libarib25.pc /build || true
RUN cp --archive --parents --no-dereference /usr/local/lib/libarib25.* /build || true
RUN cp --archive --parents --no-dereference /usr/local/lib/pkgconfig/libarib25.pc /build || true
RUN cp --archive --parents --no-dereference /usr/local/include/arib25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/recpt1 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/b25 /build
RUN cp --archive --parents --no-dereference /etc/localtime /build
RUN cp --archive --parents --no-dereference /etc/timezone /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM scratch
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
