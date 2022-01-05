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
# Create an GitLab issue via the GitLab REST API.
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
use App::Options (
	option => {
		server   => { required => 1, description => "GitLab server (with REST API v4)", default => "gitlab.com"},
		project  => { required => 1, description => "The Project ID of your repository", type => "integer" },
		token    => { required => 1, description => "GitLab personal access token", secure => 1 },
		title    => { required => 1, description => "Title", default => "New issue"},
		msg      => { required => 1, description => "Message" },
	},
);

my $server   = $App::options{server};
my $project  = $App::options{project};
my $token    = $App::options{token};
my $title    = decode('UTF-8', $App::options{title});
my $msg      = decode('UTF-8', $App::options{msg});

my $ua = LWP::UserAgent->new;
$ua->agent("notify-me-gitlab-issue");

# https://docs.gitlab.com/ee/api/issues.html#new-issue
# POST: /projects/:id/issues
my $request = POST "https://$server/api/v4/projects/$project/issues", [
	title => "$title",
	description => "$msg"
];
$request->header('PRIVATE-TOKEN' => "$token");
my $response = $ua->request($request);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent!\nStatus: '". $response->status_line ."'\nContent: '" . $response->decoded_content ."'\n";
}
