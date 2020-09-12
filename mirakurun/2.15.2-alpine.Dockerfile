# libarib25, recpt1
FROM collelog/recpt1-build:latest-alpine AS recpt1-image


# arib-b25-stream-test
FROM collelog/arib-b25-stream-test-build:latest-alpine AS arib-b25-stream-test-image


# mirakurun-build
FROM collelog/buildenv:node12-alpine AS mirakurun-build

ENV DOCKER="YES"

RUN npm install mirakurun@2.15.2 -g --unsafe-perm --production
RUN sed -i -e 's/--max_old_space_size=512/--max_old_space_size=1024/g' /usr/local/lib/node_modules/mirakurun/package.json

RUN cp --archive --parents --no-dereference /usr/local/lib/node_modules/mirakurun /build

RUN npm cache verify
RUN rm -rf /tmp/* /var/cache/apk/*


# final image
FROM node:12-alpine
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

EXPOSE 40772
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib
ENV DOCKER="YES"

# libarib25, recpt1
COPY --from=recpt1-image /build /

# arib-b25-stream-test
COPY --from=arib-b25-stream-test-image /build /

# mirakurun
COPY --from=mirakurun-build /build /


COPY services.sh /usr/local/bin

RUN set -eux && \
	apk upgrade --update && \
	apk add --no-cache \
		ccid \
		libstdc++ \
		pcsc-lite \
		pcsc-lite-libs \
		tzdata && \
	\
	# cleaning
	npm cache verify && \
	rm -rf /tmp/* ~/.npm /var/cache/apk/* && \
	\
	chmod 755 /usr/local/bin/services.sh

WORKDIR /usr/local/lib/node_modules/mirakurun
ENTRYPOINT ["/usr/local/bin/services.sh"]
CMD []
