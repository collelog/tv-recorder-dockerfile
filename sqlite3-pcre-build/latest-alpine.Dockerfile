# sqlite3-pcre
FROM collelog/buildenv:alpine AS sqlite3-pcre-build

RUN apk add --no-cache --update-cache \
	pcre-dev \
	sqlite-dev

WORKDIR /tmp/sqlite3-pcre
RUN curl -fsSLo master.zip https://github.com/l3tnun/sqlite3-pcre/archive/refs/heads/master.zip
RUN unzip master.zip
WORKDIR /tmp/sqlite3-pcre/sqlite3-pcre-master
RUN make -j $(nproc)


WORKDIR /build/usr/lib/sqlite3
RUN cp /tmp/sqlite3-pcre/sqlite3-pcre-master/pcre.so /build/usr/lib/sqlite3

RUN rm -rf /tmp/* /var/tmp/*


# final image
FROM alpine:latest
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=sqlite3-pcre-build /build /build
