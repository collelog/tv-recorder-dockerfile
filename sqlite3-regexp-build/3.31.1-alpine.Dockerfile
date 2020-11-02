# sqlite3-regexp
FROM collelog/buildenv:alpine AS build

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN apk add --no-cache --update-cache \
	gcc \
	musl

WORKDIR /tmp/sqlite3-regexp
RUN curl -fsSLo sqlite-amalgamation.zip https://www.sqlite.org/2020/sqlite-amalgamation-3310100.zip
RUN unzip sqlite-amalgamation.zip
RUN curl -fsSLo sqlite-src.zip https://www.sqlite.org/2020/sqlite-src-3310100.zip
RUN unzip sqlite-src.zip
RUN cp /tmp/sqlite3-regexp/sqlite-src-3310100/ext/misc/regexp.c /tmp/sqlite3-regexp/sqlite-amalgamation-3310100

WORKDIR /tmp/sqlite3-regexp/sqlite-amalgamation-3310100
RUN gcc -O2 -pipe -fPIC -shared regexp.c -o regexp.so

WORKDIR /build/usr/lib/sqlite3.31.1/
RUN cp /tmp/sqlite3-regexp/sqlite-amalgamation-3310100/regexp.so .

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.1
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
