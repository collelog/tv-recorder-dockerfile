# [TV Recorder on Docker] Dockerfiles
## Dockerfile
Dockerfileは、GitHub上の[collelog/tv-recorder](https://github.com/collelog/tv-recorder)で使用するDockerコンテナを構成するための設定ファイルです。
TV録画を行うためのアプリケーションであるmirakcやEPGStationなどを用意しています。また、このDockerfileで作成したDockerイメージは全て[DockerHub](https://hub.docker.com/r/collelog/)にて公開されています 。

DockerHub公開イメージの表にあるように、アプリケーションごとに異なるDockerfileが用意されており、それぞれのDockerfileは依存するイメージを含んでいます。
例えばmirakcのDockerfileは、recpt1やrecdvb、recfsusb2nとlibarib25、arib-b25-stream-testのバイナリを含んでいます。

## DockerHub公開イメージ
| アプリケーション | 公開イメージタグ | 依存イメージ | Dockerfile |
| ---- | ---- | ---- | ---- |
| [EPGStation](https://github.com/l3tnun/EPGStation) | [collelog/epgstation](https://hub.docker.com/r/collelog/epgstation) | | ./epgstation/ |
| | | [collelog/epgstation-build](https://hub.docker.com/r/collelog/epgstation-build) | ./epgstation-build/ |
| [mirakc](https://github.com/mirakc/mirakc) | [collelog/mirakc](https://hub.docker.com/r/collelog/mirakc) |  | ./mirakc/ |
| | | [mirakc/mirakc](https://hub.docker.com/r/mirakc/mirakc) | |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| | | [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/arib-b25-stream-test-build) | ./arib-b25-stream-test-build/ |
| [Mirakurun](https://github.com/Chinachu/Mirakurun) | [collelog/mirakurun](https://hub.docker.com/r/collelog/mirakurun) | | ./mirakurun/ |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| | | [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/arib-b25-stream-test-build) | ./arib-b25-stream-test-build/ |
| [MariaDB](https://mariadb.org/) | [collelog/mariadb](https://hub.docker.com/r/collelog/mariadb) |  | ./mariadb/ |
| [xTeVe](https://xteve.de/) | [collelog/xteve](https://hub.docker.com/r/collelog/xteve) | | GitHub:[collelog/xteve](https://github.com/collelog/xteve) |
| チャンネルスキャン | [collelog/tvchannels-scan](https://hub.docker.com/r/collelog/tvchannels-scan) | | ./tvchannels-scan/ || | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/epgdump-build](https://hub.docker.com/r/collelog/epgdump-build) | ./epgdump-build/ |
| | | [collelog/recpt1-build](https://hub.docker.com/r/collelog/recpt1-build) | ./recpt1-build/ |
| | | [collelog/recdvb-build](https://hub.docker.com/r/collelog/recdvb-build) | ./recdvb-build/ |
| | | [collelog/recfsusb2n-build](https://hub.docker.com/r/collelog/recfsusb2n-build) | ./recfsusb2n-build/ |
| | | [collelog/libarib25-build](https://hub.docker.com/r/collelog/libarib25-build) | ./libarib25-build/ |
| B25サーバ | [collelog/b25-server](https://hub.docker.com/r/collelog/b25-server) | | ./b25-server/ |
| | | [collelog/arib-b25-stream-test-build](https://hub.docker.com/r/collelog/arib-b25-stream-test-build) | ./arib-b25-stream-test-build/ |

## License
このソースコードは [MIT License](https://github.com/collelog/tv-recorder-dockerfile/blob/master/LICENSE) のもとでリリースします。  
ただし当Dockerfileで作成されるDockerイメージに内包される各種アプリケーションで使用されるライセンスは異なります。各プロジェクト内のLICENSE, COPYING, COPYRIGHT, READMEファイルまたはソースコード内のアナウンスを参照してください。
