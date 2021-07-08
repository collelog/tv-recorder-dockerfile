# EPGStation
FROM collelog/epgstation-build:latest-debian AS epgstation-build


# final image
FROM node:14.17.3-buster-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/lib64:/lib64:/usr/local/lib:/usr/lib:/lib

# EPGStation
COPY --from=epgstation-build /build /

RUN set -eux && \
	apt-get update -qq && \
	apt-get install -y --no-install-recommends \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg2 \
		lsb-release \
		sqlite3-pcre \
		tzdata && \
	\
	cd /tmp && \
	curl -s https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add - && \
	echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/debian $( lsb_release -c -s ) main" | tee /etc/apt/sources.list.d/jellyfin.list && \
	curl -s https://keyserver.ubuntu.com/pks/lookup?op=get\&search=0x6587ffd6536b8826e88a62547876ae518cbcf2f2 | apt-key add - && \
	echo "deb [arch=$( dpkg --print-architecture )] http://ppa.launchpad.net/ubuntu-raspi2/ppa-nightly/ubuntu $( lsb_release -c -s ) mainn" | tee /etc/apt/sources.list.d/raspbins.list && \
	\
	apt-get update -qq && \
	apt-get install -y --no-install-recommends \
		jellyfin-ffmpeg \
		libomxil-bellagio0 \
		libomxil-bellagio-bin \
		libraspberrypi0 && \
	\
	ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
	ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe && \
	\
	# cleaning
	npm cache verify && \
	apt-get clean && \
	rm -rf /tmp/* ~/.npm /var/cache/apk/*

WORKDIR /opt/epgstation

EXPOSE 8888
EXPOSE 8889
VOLUME /opt/epgstation/config
VOLUME /opt/epgstation/data
VOLUME /opt/epgstation/logs
VOLUME /opt/epgstation/recorded
VOLUME /opt/epgstation/thumbnail
ENTRYPOINT ["npm"]
CMD ["start"]
