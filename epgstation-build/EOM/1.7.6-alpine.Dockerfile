# EPGStation
FROM collelog/buildenv:node14-alpine AS epgstation-build

WORKDIR /opt/epgstation
RUN curl -fsSL https://github.com/l3tnun/EPGStation/archive/v1.7.6.tar.gz | \
		tar -xz --strip-components=1
RUN npm ci --python=/usr/bin/python3
RUN npm run build

WORKDIR /build
RUN cp --archive --parents --no-dereference /opt/epgstation /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM node:14.16.1-alpine3.13
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=epgstation-build /build /build
