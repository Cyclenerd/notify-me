
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

## Images

* [Command-line interface (CLI) Docker image](cli/)
* [HTTP API Docker image](http/)
