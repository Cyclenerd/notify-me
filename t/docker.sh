#!/usr/bin/env bash

# Test Docker image

echo "» test.pl"
if ! docker run notify-me test.pl --version; then
	exit 9
fi

for MY_PERL_SCRIPT in ../*.pl; do
	echo "» $MY_PERL_SCRIPT"
	if ! docker run notify-me "$MY_PERL_SCRIPT" --version; then
		exit 9
	fi
done
