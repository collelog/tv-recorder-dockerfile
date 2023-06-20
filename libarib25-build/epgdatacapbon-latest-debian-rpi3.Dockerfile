# epgdatacapbon libarib25
FROM collelog/buildenv:debian-bookworm AS libarib25-build

ENV DEBIAN_FRONTEND=noninteractive

COPY ./arib-b25-stream /tmp/
COPY ./patch/epgdatacapbon/CMakeLists-rpi3.patch /tmp/

WORKDIR /tmp
RUN chmod 755 ./arib-b25-stream
RUN mv ./arib-b25-stream /usr/local/bin/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
	libpcsclite-dev

WORKDIR /tmp/libarib25
RUN curl -kfsSL https://github.com/epgdatacapbon/libarib25/tarball/master | \
		tar -xz --strip-components=1
RUN mv /tmp/*.patch /tmp/libarib25/
RUN patch < CMakeLists-rpi3.patch
RUN cmake -DCMAKE_BUILD_TYPE=Release -DLDCONFIG_EXECUTABLE=IGNORE .
RUN make -j $(nproc) install

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/lib/libarib25.* /build
RUN cp --archive --parents --no-dereference /usr/local/lib/pkgconfig/libarib25.pc /build
RUN cp --archive --parents --no-dereference /usr/local/include/arib25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/b25 /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream /build

RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*


# final image
FROM debian:bookworm-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=libarib25-build /build /build
