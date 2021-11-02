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
# Send plain text message via Mailgun API
#    https://documentation.mailgun.com/en/latest/api-sending.html#sending
#
# Help: https://github.com/Cyclenerd/notify-me


BEGIN {
	$VERSION = "1.0";
}
use utf8;
binmode(STDOUT, ":utf8");
use strict;
use LWP::UserAgent;
# HTTP::Request::Common is a dependency of LWP::UserAgent
use HTTP::Request::Common;
use App::Options (
	option => {
		key     => { required => 1, description => "Your Sending API key", secure => 1 },
		domain  => { required => 1, description => "Your domain name" },
		from    => { required => 1, description => "Sender of the message" },
		to      => { required => 1, description => "Recipient of the message" },
		title   => { required => 1, description => "Your subject", default => "Hello from mailgun.pl" },
		msg     => { required => 1, description => "Your message" },
	},
);

my $url = "https://api.mailgun.net/v3/".$App::options{domain}."/messages";

my $ua = LWP::UserAgent->new;
my $request = POST "$url", [
	from    => $App::options{from},
	to      => $App::options{to},
	subject => $App::options{title},
	text    => $App::options{msg},
];
$request->authorization_basic("api", $App::options{key});
my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}
