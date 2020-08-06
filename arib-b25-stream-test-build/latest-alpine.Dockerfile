# arib-b25-stream-test
FROM collelog/buildenv:node12-alpine-jst AS build

RUN apk add --no-cache --update \
	pcsc-lite-dev

RUN npm install arib-b25-stream-test -g --unsafe
RUN cp -r /usr/local/lib/node_modules/arib-b25-stream-test /usr/local/arib-b25-stream-test
RUN ln -sf /usr/local/arib-b25-stream-test/bin/b25 /usr/local/bin/arib-b25-stream-test

RUN mkdir /build
RUN cp --archive --parents --no-dereference /usr/local/arib-b25-stream-test /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream-test /build
RUN cp --archive --parents --no-dereference /etc/localtime /build
RUN cp --archive --parents --no-dereference /etc/timezone /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM scratch
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
