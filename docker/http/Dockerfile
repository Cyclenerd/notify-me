# Copyright 2021 Nils Knieling. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM debian:bullseye-slim

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Labels
LABEL org.opencontainers.image.title         "Notify me"
LABEL org.opencontainers.image.description   "Get notified via MS Teams, sipgate SMS, Pushover and many more..."
LABEL org.opencontainers.image.url           "https://hub.docker.com/r/cyclenerd/notify-me"
LABEL org.opencontainers.image.authors       "https://github.com/Cyclenerd/notify-me/graphs/contributors"
LABEL org.opencontainers.image.documentation "https://github.com/Cyclenerd/notify-me/blob/master/README.md"
LABEL org.opencontainers.image.source        "https://github.com/Cyclenerd/notify-me"

# Install base packages
RUN set -eux; \
	apt-get update -yqq; \
	apt-get install -yqq libdancer2-perl starman libwww-perl libapp-options-perl libjson-xs-perl ; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app
# Copy wrapper app
COPY ./http/NotifyMe-HTTP/ /app/
# Copy scripts
COPY ./t/test.pl /app/
COPY ./*.pl /app/

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run
CMD ["/bin/sh", "start.sh"]

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/Cyclenerd/notify-me/issues