
# Docker

Docker Hub: <https://hub.docker.com/r/cyclenerd/notify-me>

## Pull

```shell
docker pull cyclenerd/notify-me:latest
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

Pass [environment variables](../README.md#environment-variables) to container:
```shell
docker run --env APP_MSG=test cyclenerd/notify-me:latest pushover.pl --help
```

## Build

```text
$  ls *.pl
ms-teams.pl  pushover.pl  sipgate-sms.pl
$ docker build -t cyclenerd/notify-me:latest -f docker/cli/Dockerfile .
```
