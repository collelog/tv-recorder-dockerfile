# epgdatacapbon libarib25
FROM collelog/buildenv:alpine AS libarib25-build

COPY ./arib-b25-stream /tmp/
COPY ./patch/epgdatacapbon/CMakeLists.patch /tmp/

WORKDIR /tmp
RUN chmod 755 ./arib-b25-stream
RUN mv ./arib-b25-stream /usr/local/bin/

RUN apk add --no-cache --update-cache \
	pcsc-lite-dev

WORKDIR /tmp/libarib25
RUN curl -fsSL https://github.com/epgdatacapbon/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/libarib25/
RUN patch < CMakeLists.patch
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/lib/libarib25.* /build
RUN cp --archive --parents --no-dereference /usr/local/lib/pkgconfig/libarib25.pc /build
RUN cp --archive --parents --no-dereference /usr/local/include/arib25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/b25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream /build

RUN rm -rf /tmp/* /var/tmp/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=libarib25-build /build /build
