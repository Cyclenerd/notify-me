#!/usr/bin/env bash

# Test compilation

echo "» test.pl"
if ! perl test.pl --version; then
	exit 9
fi

for MY_PERL_SCRIPT in ../*.pl; do
	echo "» $MY_PERL_SCRIPT"
	if ! perl "$MY_PERL_SCRIPT" --version; then
		exit 9
	fi
done
