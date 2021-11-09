#!/usr/bin/env bash

export PERL5LIB=./lib/
export API_KEY=$(echo $RANDOM | md5sum | head -c 20)

for MY_PERL_TEST_SCRIPT in t/*.t; do
	echo "» $MY_PERL_TEST_SCRIPT"
	if ! perl "$MY_PERL_TEST_SCRIPT"; then
		exit 9
	fi
done