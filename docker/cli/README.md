# Command-line interface (CLI) Docker image

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

All other scripts and notification services are called in the same way.

### Microsoft Teams (`ms-teams.pl`)

Run:
```
docker run cyclenerd/notify-me:latest ms-teams.pl --help
```

### Pushover (`pushover.pl`)

Run:
```
docker run cyclenerd/notify-me:latest pushover.pl --help
```

## Environment Variables

Pass [environment variables](https://github.com/Cyclenerd/notify-me#environment-variables) to container:
```shell
docker run --env APP_MSG=test cyclenerd/notify-me:latest pushover.pl --help
```

## Build

```text
$  ls *.pl
ms-teams.pl  pushover.pl  sipgate-sms.pl
$ docker build -t cyclenerd/notify-me:latest -f docker/cli/Dockerfile .
```