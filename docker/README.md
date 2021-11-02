
# Docker

The Docker images are based on the corresponding Ubuntu to [Debian](https://hub.docker.com/_/debian) version.

You can find the Debian version on which your Ubuntu version is based in the file: `/etc/debian_version`

| Ubuntu        | Debian      |
|---------------|-------------|
| 20.04 focal   | 11 bullseye |
| 18.04 bionic  | 10 buster   |

Currently the latest available [GitHub Actions virtual environments](https://github.com/actions/virtual-environments) is Ubuntu 20.04 (`ubuntu-latest` or `ubuntu-20.04`).
The Docker images are therefore based on `debian:bullseye-slim`.

This makes test easier.

## Registries

* Docker Hub: <https://hub.docker.com/r/cyclenerd/notify-me>
* GitHub: <https://github.com/Cyclenerd/notify-me/pkgs/container/notify-me>

## Pull

Docker Hub registry:
```shell
docker pull cyclenerd/notify-me:latest
```

GitHub Container registry:
```shell
docker pull ghcr.io/cyclenerd/notify-me:latest
```

## Run

### Microsoft Teams

Run:
```shell
docker run cyclenerd/notify-me:latest ms-teams.pl --help
```

### sipgate SMS

Run:
```shell
docker run cyclenerd/notify-me:latest sipgate-sms.pl --help
```

### Pushover

Run:
```shell
docker run cyclenerd/notify-me:latest pushover.pl --help
```

## Environment Variables

Pass [environment variables](https://github.com/Cyclenerd/notify-me#environment-variables) to container:
```shell
docker run --env APP_MSG=test cyclenerd/notify-me:latest pushover.pl --help
```

## HTTP image

Pull from Docker Hub registry:
```shell
docker pull cyclenerd/notify-me:http-latest
```

Run:
```
docker run --env API_KEY=foo -p 127.0.0.1:8080:8080/tcp cyclenerd/notify-me:http-latest
```

message.json:
```json
{
	"title" : "Your title",
	"msg" : "Your message"
}
```

Pass other options as [environment variables](https://github.com/Cyclenerd/notify-me#environment-variables) to container.

Send message:
```
curl -i \
	-H "Content-Type: application/json" \
	--data @message.json \
	http://localhost:8080/v1/ms-teams.pl?key=foo
```

## Build

### CLI image

```text
$  ls *.pl
ms-teams.pl  pushover.pl  sipgate-sms.pl
$ docker build -t cyclenerd/notify-me:latest -f docker/cli/Dockerfile .
```

### HTTP image

```text
$  ls *.pl
ms-teams.pl  pushover.pl  sipgate-sms.pl
$ docker build -t cyclenerd/notify-me:http-latest -f docker/http/Dockerfile .
```