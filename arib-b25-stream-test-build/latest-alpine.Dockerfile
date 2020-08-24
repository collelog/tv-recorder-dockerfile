# arib-b25-stream-test
FROM collelog/buildenv:node12-alpine AS build

RUN apk add --no-cache --update \
	pcsc-lite-dev

WORKDIR /tmp
RUN npm install arib-b25-stream-test --unsafe
RUN cp /tmp/node_modules/.bin/arib-b25-stream-test /usr/local/bin/arib-b25-stream-test

WORKDIR /build
RUN cp --archive --parents --no-dereference /usr/local/bin/arib-b25-stream-test /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM alpine:3.12.0
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
