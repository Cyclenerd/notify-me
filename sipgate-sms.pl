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
# Send an SMS via the sipgate REST API
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
		id    => { required => 1, description => "Your sipgate token id (example: token-FQ1V12)" },
		token => { required => 1, description => "Your sipgate token (example: e68ead46-a7db-46cd-8a1a-44aed1e4e372)", secure => 1 },
		sms   => { required => 0, description => "Your sipgate SMS extension id (default: s0)", default => 's0' },
		tel   => { required => 1, description => "Phone number of the SMS recipient (example: 49157...)", type => "integer" },
		msg   => { required => 1, description => "SMS message" },
	},
);

# Create JSON for content body
my %json;
$json{smsId}     = $App::options{sms};
$json{recipient} = $App::options{tel};
$json{message}   = $App::options{msg};
# Convert Perl hash to JSON
my $json_text = encode_json \%json;

my $ua = LWP::UserAgent->new;
my $request = POST 'https://api.sipgate.com/v2/sessions/sms';
$request->authorization_basic($App::options{id}, $App::options{token});
$request->header( 'Content-Type' => 'application/json', 'Content-Length' => length($json_text) );
$request->content( $json_text );
my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	# Error codes: https://github.com/sipgate-io/sipgateio-sendsms-php#http-errors
	die "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}
