#!/usr/bin/perl

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
#
# Only needed for CI/CD test
#
# Help: https://github.com/Cyclenerd/notify-me

BEGIN {
	$VERSION = "1.0";
}
use utf8;
binmode(STDOUT, ":utf8");
use strict;
use App::Options (
	option => {
		env   => { required => 0, description => "For environment variable test" },
		title => { required => 0, description => "Title for command line argument test" },
		msg   => { required => 1, description => "Message for command line argument test" },
	},
);

my $file = "/tmp/notiy-me-tmp-test";
open(DATA, ">$file") or die "Couldn't open file '$file', $!";

print DATA "env   = $App::options{env}\n";
print DATA "title = $App::options{title}\n";
print DATA "msg   = $App::options{msg}\n";

close DATA;

print "OK"