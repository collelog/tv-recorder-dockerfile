cd /d %~dp0

docker buildx build --ulimit 51200 --platform linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 -t collelog/epgstation-build:1.7.3-alpine -f 1.7.3-alpine.Dockerfile .\ --push

exit