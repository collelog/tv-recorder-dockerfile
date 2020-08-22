# arib-b25-stream-test
FROM collelog/buildenv:node12-alpine-jst AS build

RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp
RUN npm install arib-b25-stream-test -g --unsafe
RUN cp /tmp/node_modules/.bin/arib-b25-stream-test /usr/local/bin/arib-b25-stream-test

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream-test /build
RUN cp --archive --parents --no-dereference /etc/localtime /build
RUN cp --archive --parents --no-dereference /etc/timezone /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM scratch
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
