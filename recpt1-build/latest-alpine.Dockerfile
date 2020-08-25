# libarib25, recpt1
FROM collelog/buildenv:alpine AS recpt1-build

COPY ./arib-b25-stream /tmp/

WORKDIR /tmp
RUN chmod 755 ./arib-b25-stream
RUN mv ./arib-b25-stream /usr/local/bin/

RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make install

WORKDIR /tmp/recpt1
RUN curl -fsSL https://github.com/stz2012/recpt1/tarball/master | \
		tar -xz --strip-components=1
WORKDIR /tmp/recpt1/recpt1
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
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=recpt1-build /build /build
