# libarib25
FROM collelog/buildenv:alpine AS libarib25-build

COPY ./arib-b25-stream /tmp/
COPY ./patch/CMakeLists-rpi4-arm64v8.patch /tmp/

RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp
RUN chmod 755 ./arib-b25-stream
RUN mv ./arib-b25-stream /usr/local/bin/

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/stz2012/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/CMakeLists-rpi4-arm64v8.patch /tmp/libarib25/
RUN patch < CMakeLists-rpi4-arm64v8.patch
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/lib64/libarib25.* /build
RUN cp --archive --parents --no-dereference /usr/local/lib64/pkgconfig/libarib25.pc /build
RUN cp --archive --parents --no-dereference /usr/local/include/arib25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/b25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=libarib25-build /build /build
