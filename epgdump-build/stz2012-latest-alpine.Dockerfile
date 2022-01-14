# stz2012 epgdump
FROM collelog/buildenv:alpine AS epgdump-build

WORKDIR /tmp/epgdump
RUN curl -fsSL https://github.com/stz2012/epgdump/tarball/master | \
		tar -xz --strip-components=1
RUN make -j $(nproc)
RUN make -j $(nproc) install

RUN cp --archive --parents --no-dereference /usr/local/bin/epgdump /build

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:latest
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=epgdump-build /build /build
