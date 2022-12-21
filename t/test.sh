#!/usr/bin/env bash

# Test compilation

for MY_PERL_SCRIPT in ../*.pl; do
	echo "» $MY_PERL_SCRIPT"
	if ! perl "$MY_PERL_SCRIPT" --version; then
		exit 9
	fi
done
