# EPGStation
FROM collelog/buildenv:node16-debian AS epgstation-build

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/epgstation
ENV DOCKER="YES"
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
FROM node:16-buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=epgstation-build /build /build
