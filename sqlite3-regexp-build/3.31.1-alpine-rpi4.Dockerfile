# sqlite3-regexp
FROM collelog/buildenv:alpine AS build

WORKDIR /tmp/sqlite3-regexp
RUN curl -fsSLo sqlite-amalgamation.zip https://www.sqlite.org/2020/sqlite-amalgamation-3310100.zip
RUN unzip sqlite-amalgamation.zip
RUN curl -fsSLo sqlite-src.zip https://www.sqlite.org/2020/sqlite-src-3310100.zip
RUN unzip sqlite-src.zip
RUN cp /tmp/sqlite3-regexp/sqlite-src-3310100/ext/misc/regexp.c /tmp/sqlite3-regexp/sqlite-amalgamation-3310100

WORKDIR /tmp/sqlite3-regexp/sqlite-amalgamation-3310100
RUN gcc -O2 -pipe -march=armv8-a+crc+simd -mtune=cortex-a72 -fPIC -shared regexp.c -o regexp.so

WORKDIR /build/usr/lib/sqlite3.31.1/
RUN cp /tmp/sqlite3-regexp/sqlite-amalgamation-3310100/regexp.so .

RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.13.5
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
