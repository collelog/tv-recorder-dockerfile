cd /d %~dp0

docker buildx build --platform linux/amd64,linux/arm64 -t collelog/epgstation-build:1.7.4-debian -f 1.7.4-debian.Dockerfile .\ --push
