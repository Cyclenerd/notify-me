# HTTP Wrapper

HTTP wrapper for Perl command line scripts.

Based on [Dancer](https://www.perldancer.org/) Perl web framework.

```
cd NotifyMe-HTTP
```

## Requirement

* Perl 5 (`perl`)
* [Dancer2](https://metacpan.org/pod/Dancer2)
* [Starman](https://metacpan.org/pod/Starman) (*high-performance Perl PSGI web server only for production*)

Debian/Ubuntu:
```shell
sudo apt update
sudo apt install libdancer2-perl
# Production only
#sudo apt install starman
```

Or install modules with cpanminus:
```shell
cpan App::cpanminus
cpanm --installdeps .
```

## Development

Start:
```
export APP_ENV="Test env"
export API_KEY="$(echo $RANDOM | md5sum | head -c 20)"
echo "Your API key: $API_KEY"
plackup bin/app.psgi -l 127.0.0.1:8080
```

First test:
```
curl -i http://localhost:8080/?key=$API_KEY
```

Test JSON:
```
curl -i \
	-H "Content-Type: application/json" \
	--data @t/test.json \
	http://localhost:8080/v1/tmp.pl?key=$API_KEY
grep "Test env"     < /tmp/notiy-me-tmp-test
grep "Test title"   < /tmp/notiy-me-tmp-test
grep "Test message" < /tmp/notiy-me-tmp-test
```

Test Google Monitoring JSON message:
```
curl -i \
	-H "Content-Type: application/json" \
	--data @t/google-test.json \
	http://localhost:8080/v1/tmp.pl?key=$API_KEY
grep "Test title"   < /tmp/notiy-me-tmp-test
grep "Test message" < /tmp/notiy-me-tmp-test
```

## Production

Start:
```
export API_KEY="$(echo $RANDOM | md5sum | head -c 20)"
plackup -E production -s Starman --workers=2 -l 127.0.0.1:8080 -a bin/app.psgi
```
