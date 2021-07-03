# sqlite3-pcre2
FROM collelog/buildenv:alpine AS sqlite3-pcre2-build

RUN apk add --no-cache --update-cache \
	pcre2-dev

WORKDIR /tmp/sqlite3-pcre2
RUN curl -fsSLo main.zip https://github.com/pfmoore/sqlite3-pcre2/archive/refs/heads/main.zip
RUN unzip main.zip
WORKDIR /tmp/sqlite3-pcre2/sqlite3-pcre2-main/src
RUN cmake -DCMAKE_BUILD_TYPE=Release .
RUN make -j $(nproc)


WORKDIR /build/usr/lib/sqlite3
RUN cp /tmp/sqlite3-pcre2/sqlite3-pcre2-main/src/libsqlite_pcre.so /build/usr/lib/sqlite3

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=sqlite3-pcre2-build /build /build
