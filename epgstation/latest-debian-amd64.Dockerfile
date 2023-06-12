# EPGStation
FROM collelog/epgstation-build:latest-debian AS epgstation-build


# final image
FROM node:16-bullseye-slim
LABEL maintainer "collelog <collelog.cavamin@gmail.com>"

# https://askubuntu.com/questions/972516/debian-frontend-environment-variable
ARG DEBIAN_FRONTEND="noninteractive"
# http://stackoverflow.com/questions/48162574/ddg#49462622
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
# https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(Native-GPU-Support)
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# https://github.com/intel/compute-runtime/releases
ARG GMMLIB_VERSION=22.0.2
ARG IGC_VERSION=1.0.10395
ARG NEO_VERSION=22.08.22549
ARG LEVEL_ZERO_VERSION=1.3.22549

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
	apt-get update -qq && \
	apt-get install -y --no-install-recommends --no-install-suggests -y \
		jellyfin-ffmpeg6 \
		mesa-va-drivers && \
	# Intel VAAPI Tone mapping dependencies:
	# Prefer NEO to Beignet since the latter one doesn't support Comet Lake or newer for now.
	# Do not use the intel-opencl-icd package from repo since they will not build with RELEASE_WITH_REGKEYS enabled.
	cd /tmp && \
	wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-gmmlib_${GMMLIB_VERSION}_amd64.deb && \
	wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-core_${IGC_VERSION}_amd64.deb && \
	wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-${IGC_VERSION}/intel-igc-opencl_${IGC_VERSION}_amd64.deb && \
	wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-opencl-icd_${NEO_VERSION}_amd64.deb && \
	wget https://github.com/intel/compute-runtime/releases/download/${NEO_VERSION}/intel-level-zero-gpu_${LEVEL_ZERO_VERSION}_amd64.deb && \
	dpkg -i *.deb && \
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
