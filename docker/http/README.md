# HTTP Docker image (HTTP API)

## Pull

Docker Hub registry:
```shell
docker pull cyclenerd/notify-me:http-latest
```

GitHub Container registry:
```shell
docker pull ghcr.io/cyclenerd/notify-me:latest
```

## Run HTTP API

```
docker run --env API_KEY=foo -p 127.0.0.1:8080:8080/tcp cyclenerd/notify-me:http-latest
```

## JSON structure

message.json:
```json
{
	"title" : "Your title",
	"msg" : "Your message"
}
```

Pass other options as [environment variables](https://github.com/Cyclenerd/notify-me#environment-variables) to container.

## Run

All other scripts and notification services are called in the same way.

### Microsoft Teams (`ms-teams.pl`)

```
curl -i \
	-H "Content-Type: application/json" \
	--data @message.json \
	http://localhost:8080/v1/ms-teams.pl?key=foo
```

### Pushover (`pushover.pl`)

```
curl -i \
	-H "Content-Type: application/json" \
	--data @message.json \
	http://localhost:8080/v1/pushover.pl?key=foo
```

## Build

```text
$  ls *.pl
ms-teams.pl  pushover.pl  sipgate-sms.pl
$ docker build -t cyclenerd/notify-me:http-latest -f docker/http/Dockerfile .
```