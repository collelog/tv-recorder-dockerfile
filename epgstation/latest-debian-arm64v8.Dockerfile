# EPGStation
FROM collelog/epgstation-build:latest-debian AS epgstation-build


# final image
FROM node:16-bullseye-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

# https://askubuntu.com/questions/972516/debian-frontend-environment-variable
ARG DEBIAN_FRONTEND="noninteractive"
# http://stackoverflow.com/questions/48162574/ddg#49462622
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

# EPGStation
COPY --from=epgstation-build /build /

RUN set -eux && \
	apt-get update -qq && \
	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends --no-install-suggests -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		sqlite3-pcre \
		tzdata \
		wget && \
	wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | apt-key add - && \ 
	echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | tee /etc/apt/sources.list.d/jellyfin.list && \
	wget -O - https://archive.raspberrypi.org/debian/raspberrypi.gpg.key | apt-key add - && \ 
	echo "deb [arch=$( dpkg --print-architecture )] https://archive.raspberrypi.org/debian $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | tee -a /etc/apt/sources.list && \
	apt-get update -qq && \
	apt-get install -y --no-install-recommends --no-install-suggests -y \
		jellyfin-ffmpeg6 \
		libomxil-bellagio0 \
		libomxil-bellagio-bin \
		libraspberrypi0 && \
	\
	ln -s /usr/lib/jellyfin-ffmpeg/ffmpeg /usr/local/bin/ffmpeg && \
	ln -s /usr/lib/jellyfin-ffmpeg/ffprobe /usr/local/bin/ffprobe && \
	ln -s /usr/lib/sqlite3/pcre.so /opt/epgstation/pcre.so && \
	\
	# cleaning
	npm cache verify && \
	apt-get clean && \
	rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* ~/.npm

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
