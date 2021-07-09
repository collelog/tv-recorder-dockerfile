# EPGStation
FROM collelog/buildenv:node14-debian AS epgstation-build

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/epgstation
RUN curl -fsSL https://github.com/l3tnun/EPGStation/tarball/master | \
		tar -xz --strip-components=1
RUN npm run all-install --python=/usr/bin/python3
RUN npm run build

WORKDIR /build
RUN cp --archive --parents --no-dereference /opt/epgstation /build

RUN npm cache verify
RUN apt-get clean
RUN rm -rf /tmp/* /var/lib/apt/lists/*

# final image
FROM node:14-buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=epgstation-build /build /build
