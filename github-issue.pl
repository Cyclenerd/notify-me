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
# Create an GitHub issue via the GitHub REST API.
#
# Help: https://github.com/Cyclenerd/notify-me

BEGIN {
	$VERSION = "1.0.0";
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
		owner    => { required => 1, description => "The repository owner" },
		repo     => { required => 1, description => "The repository name" },
		username => { required => 1, description => "GitHub username" },
		token    => { required => 1, description => "GitHub personal access token", secure => 1 },
		title    => { required => 1, description => "Title", default => "New issue"},
		msg      => { required => 1, description => "Message" },
	},
);

my $owner    = $App::options{owner};
my $repo     = $App::options{repo};
my $username = $App::options{username};
my $token    = $App::options{token};
my $title    = decode('UTF-8', $App::options{title});
my $msg      = decode('UTF-8', $App::options{msg});

# Create JSON for content body
my %json;
$json{title} = $title;
$json{body}  = $msg;
# Convert Perl hash to JSON
my $json_text = encode_json(\%json);

my $ua = LWP::UserAgent->new;
$ua->agent("notify-me-github-issue");

# https://docs.github.com/en/rest/reference/issues#create-an-issue
# POST: /repos/{owner}/{repo}/issues
my $request = POST "https://api.github.com/repos/$owner/$repo/issues";
$request->header(
	'Accept'         => 'application/vnd.github.v3+json',
	'Content-Length' => length($json_text)
);
$request->content( $json_text );
$request->authorization_basic("$username", "$token");

my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent!\nStatus: '". $response->status_line ."'\nContent: '" . $response->decoded_content ."'\n";
}
