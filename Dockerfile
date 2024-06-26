# Copyright 2021-2023 Nils Knieling. All Rights Reserved.
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

FROM ubuntu:24.04

ARG TARGETPLATFORM
RUN echo "I'm building for $TARGETPLATFORM"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Set debconf frontend to noninteractive
ENV DEBIAN_FRONTEND noninteractive

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
	apt-get install -yqq libwww-perl libapp-options-perl libjson-xs-perl; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY ./*.pl /usr/local/bin/

RUN set -eux; \
	chmod +x /usr/local/bin/*.pl

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/Cyclenerd/notify-me/issues