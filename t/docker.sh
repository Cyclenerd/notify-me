#!/usr/bin/env bash

# Test Docker image

for MY_PERL_SCRIPT in *.pl; do
	echo "» $MY_PERL_SCRIPT"
	if ! docker run notify-me "$MY_PERL_SCRIPT" --version; then
		exit 9
	fi
done
