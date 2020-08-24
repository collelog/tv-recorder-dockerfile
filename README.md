# [TV Recorder on Docker] Dockerfiles
>[collelog/tv-recorder](https://github.com/collelog/tv-recorder) プロジェクトを構成するDockerイメージのDockerfileです。

Dockerfileで作成したDockerイメージは全てDocker Hubにて公開しています。  
対象プラットフォームはamd64(x86-64),arm64v8,arm32v7,arm32v6です。

## Docker Hub
- **EPGStation**
  - [collelog/epgstation](https://hub.docker.com/r/collelog/epgstation)
    - [collelog/epgstation-build](https://hub.docker.com/r/collelog/epgstation-build)
    - [collelog/ffmpeg](https://hub.docker.com/r/collelog/ffmpeg) ※Dockerfileは[collelog/ffmpeg](https://github.com/collelog/ffmpeg) プロジェクトにて管理しています。
- **MariaDB**
  - [collelog/mariadb](https://hub.docker.com/r/collelog/mariadb)

- **mirakc**
  - [collelog/mirakc](https://hub.docker.com/r/collelog/epgstation-build)
    - [collelog/recpt1-build](https://hub.docker.com/r/collelog/epgstation-build)
    - [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/epgstation-build)

- **xteve**
  - [collelog/xteve](https://hub.docker.com/r/collelog/epgstation-build)



## 利用ソースコード
当ソースコードは以下のソースコード（docker-compose.yml,Dockerfile,その他動作に必要なファイル一式）を改変または参考に作成しています。

- **EPGStation**
  - [l3tnun/docker-mirakurun-epgstation](https://github.com/l3tnun/docker-mirakurun-epgstation) : docker-mirakurun-epgstation
    - [MIT License](https://github.com/l3tnun/docker-mirakurun-epgstation/blob/master/LICENSE)

- **MariaDB**
  - [yobasystems/alpine-mariadb](https://github.com/yobasystems/alpine-mariadb) : MariaDB Docker image running on Alpine Linux  

- **mirakc**
  - [masnagam/mirakc](https://github.com/masnagam/mirakc) : mirakc (a Mirakurun clone written in Rust) + recdvb + recpt1
    - [Apache License, Version 2.0](https://github.com/masnagam/mirakc/blob/master/LICENSE-APACHE) or [MIT License](https://github.com/masnagam/mirakc/blob/master/LICENSE-MIT)

- **Mirakurun**
  - [Chinachu/docker-mirakurun-chinachu](https://github.com/Chinachu/docker-mirakurun-chinachu) : docker-mirakurun-chinach
    - [MIT License](https://github.com/Chinachu/docker-mirakurun-chinachu/blob/master/LICENSE)

## License
このソースコードは [MIT License](https://github.com/collelog/tv-recorder-dockerfile/blob/master/LICENSE) のもとでリリースします。  
ただし当Dockerfileで作成されるDockerイメージに内包される各種アプリケーションで使用されるライセンスは異なります。各プロジェクト内のLICENSE, COPYING, COPYRIGHT, READMEファイルまたはソースコード内のアナウンスを参照してください。
