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
# Send an Microsoft Teams message card via the Office connectors webhook API
#
# Help: https://github.com/Cyclenerd/notify-me

BEGIN {
	$VERSION = "1.0.1";
}

use utf8;
binmode(STDOUT, ':encoding(utf8)');
use strict;
use Encode;
use LWP::UserAgent;
use HTTP::Request::Common;
use JSON::XS;
use App::Options (
	option => {
		url   => { required => 1, description => "Your Teams webhook url (example: https://outlook.office.com/webhook/<group>@<tenantID>/IncomingWebhook/<chars>/<guid>)", secure => 1 },
		title => { required => 0, description => "Title" },
		msg   => { required => 1, description => "Message" },
	},
);

my $url   = $App::options{url};
my $title = decode('UTF-8', $App::options{title});
my $msg   = decode('UTF-8', $App::options{msg});

# Create JSON for content body
my %json;
$json{title} = $title if $title;
$json{text}  = $msg;
# Convert Perl hash to JSON
my $json_text = encode_json(\%json);

my $ua = LWP::UserAgent->new;
my $request = POST "$url";
$request->header( 'Content-Type' => 'application/json', 'Content-Length' => length($json_text) );
$request->content( $json_text );
my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}
