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
#     PTSV2: https://ptsv2.com/t/github-cyclenerd-notify-me
#
# Help: https://github.com/Cyclenerd/notify-me

BEGIN {
	$VERSION = "1.0";
}
use utf8;
binmode(STDOUT, ":utf8");
use strict;
use LWP::UserAgent;
use HTTP::Request::Common;
use JSON::XS;
use App::Options (
	option => {
		username => { required => 1, description => "Username", env => "PTSV2_USERNAME", },
		password => { required => 1, description => "Password", secure => 1, env => "PTSV2_PASSWORD" },
		msg      => { required => 1, description => "Test" },
	},
);

# Create JSON for content body
my %json;
$json{message} = $App::options{msg};
# Convert Perl hash to JSON
my $json_text = encode_json \%json;

my $ua = LWP::UserAgent->new;
my $request = POST 'https://ptsv2.com/t/github-cyclenerd-notify-me/post';
$request->authorization_basic($App::options{username}, $App::options{password});
$request->header( 'Content-Type' => 'application/json', 'Content-Length' => length($json_text) );
$request->content( $json_text );
my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}