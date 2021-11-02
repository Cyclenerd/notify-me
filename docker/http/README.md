# HTTP Docker image

Pull:
```shell
docker pull cyclenerd/notify-me:http-latest
```

Run:
```
docker run --env API_KEY=foo -p 127.0.0.1:8080:8080/tcp cyclenerd/notify-me:http-latest
```

Send message:
```
curl -i \
	-H "Content-Type: application/json" \
	--data @message.json \
	http://localhost:8080/v1/tmp.pl?key=foo
```
