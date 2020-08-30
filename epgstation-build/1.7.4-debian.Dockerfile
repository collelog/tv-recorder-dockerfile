# EPGStation
FROM collelog/buildenv:node14-debian AS epgstation-build

WORKDIR /opt/epgstation
RUN curl -kfsSL https://github.com/l3tnun/EPGStation/archive/v1.7.4.tar.gz | \
		tar -xz --strip-components=1
RUN npm install --nosave --python=/usr/bin/python3
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
