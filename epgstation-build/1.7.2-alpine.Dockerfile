# EPGStation
FROM collelog/buildenv:node12-alpine-jst AS epgstation-build

WORKDIR /usr/local/EPGStation
RUN curl -fsSL https://github.com/l3tnun/EPGStation/archive/v1.7.2.tar.gz | \
		tar -xz --strip-components=1
RUN npm install --nosave --python=/usr/bin/python3
RUN npm run build

RUN mkdir -p /build
RUN cp --archive --parents --no-dereference /usr/local/EPGStation /build
RUN cp --archive --parents --no-dereference /etc/localtime /build
RUN cp --archive --parents --no-dereference /etc/timezone /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM scratch
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

COPY --from=build /build /build
