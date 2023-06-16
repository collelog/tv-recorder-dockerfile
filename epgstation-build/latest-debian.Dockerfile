# EPGStation
FROM collelog/buildenv:node16-debian-bullseye AS epgstation-build

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/epgstation
ENV DOCKER="YES"
RUN npm config set registry http://registry.npmjs.org/
RUN npm config set loglevel info
RUN npm config set fetch-retries 5
RUN npm config set fetch-retry-mintimeout 15000
RUN npm config set fetch-retry-maxtimeout 90000
RUN npm config set cache-min 86400
RUN curl -kfsSL https://github.com/l3tnun/EPGStation/tarball/master | \
		tar -xz --strip-components=1
RUN npm run all-install --python=/usr/bin/python3
RUN npm run build

WORKDIR /build
RUN cp --archive --parents --no-dereference /opt/epgstation /build

RUN npm cache verify
RUN apt-get clean
RUN rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* ~/.npm

# final image
FROM node:16-bullseye-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=epgstation-build /build /build
