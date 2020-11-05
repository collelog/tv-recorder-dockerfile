# [TV Recorder on Docker] Dockerfiles
>GitHub:[collelog/tv-recorder](https://github.com/collelog/tv-recorder)を構成するDockerコンテナのDockerfileです。

当Dockerfileで作成したDockerイメージは全てDockerHubにて公開しています。  

## DockerHub公開イメージ
| アプリケーション | 公開イメージタグ | 依存イメージ | Dockerfile |
| ---- | ---- | ---- | ---- |
| [EPGStation](https://github.com/l3tnun/EPGStation) | [collelog/epgstation](https://hub.docker.com/r/collelog/epgstation) | | ./epgstation/ |
| | | [collelog/epgstation-build](https://hub.docker.com/r/collelog/epgstation-build) | ./epgstation-build/ |
| | | [collelog/sqlite3-regexp-build](https://hub.docker.com/r/collelog/sqlite3-regexp-build) | ./sqlite3-regexp-build/ |
| | | [collelog/ffmpeg](https://hub.docker.com/r/collelog/ffmpeg) | GitHub:[collelog/ffmpeg](https://github.com/collelog/ffmpeg) |
| [MariaDB](https://mariadb.org/) | [collelog/mariadb](https://hub.docker.com/r/collelog/mariadb) |  | ./mariadb/ |
| [mirakc](https://github.com/mirakc/mirakc) | [collelog/mirakc](https://hub.docker.com/r/collelog/mirakc) |  | ./mirakc/ |
| | | [mirakc/mirakc](https://hub.docker.com/r/mirakc/mirakc) | |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| | | [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/arib-b25-stream-test-build) | ./arib-b25-stream-test-build/ |
| [Mirakurun v2](https://github.com/Chinachu/Mirakurun) | [collelog/mirakurun](https://hub.docker.com/r/collelog/mirakurun) | | ./mirakurun/ |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| | | [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/arib-b25-stream-test-build) | ./arib-b25-stream-test-build/ |
| [xTeVe](https://xteve.de/) | [collelog/xteve](https://hub.docker.com/r/collelog/xteve) | | GitHub:[collelog/xteve](https://github.com/collelog/xteve) |
| チャンネルスキャン | [collelog/tvchannels-scan](https://hub.docker.com/r/collelog/tvchannels-scan) | | ./tvchannels-scan/ || | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/epgdump-build](https://hub.docker.com/r/collelog/epgdump-build) | ./epgdump-build/ |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| B25サーバ | [collelog/b25-server](https://hub.docker.com/r/collelog/b25-server) | | ./b25-server/ |

## License
このソースコードは [MIT License](https://github.com/collelog/tv-recorder-dockerfile/blob/master/LICENSE) のもとでリリースします。  
ただし当Dockerfileで作成されるDockerイメージに内包される各種アプリケーションで使用されるライセンスは異なります。各プロジェクト内のLICENSE, COPYING, COPYRIGHT, READMEファイルまたはソースコード内のアナウンスを参照してください。
