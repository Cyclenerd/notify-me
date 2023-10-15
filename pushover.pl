#!/usr/bin/perl

# Copyright 2021-2023 Nils Knieling. All Rights Reserved.
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
# Send message via Pushover API (https://pushover.net/api)
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
use App::Options (
	option => {
		user      => { required => 1, description => "The user/group key (not e-mail address) of your user [required]" },
		token     => { required => 1, description => "Your application's API token [required]", secure => 1 },
		msg       => { required => 1, description => "Your message [required]" },
		title     => { required => 0, description => "Your message's title, otherwise your app's name is used" },
		url       => { required => 0, description => "A URL to show with your message " },
		url_title => { required => 0, description => "A title for the URL specified as the url parameter, otherwise just the URL is shown" },
	},
);

my $user      = $App::options{user};
my $token     = $App::options{token};
my $msg       = decode('UTF-8', $App::options{msg});
my $title     = decode('UTF-8', $App::options{title});
my $url       = decode('UTF-8', $App::options{url});
my $url_title = decode('UTF-8', $App::options{url_title});

my %post = (
	"token"   => $token,
	"user"    => $user,
	"message" => $msg,
);
$post{'title'}     = $title if $title;
$post{'url'}       = $url if $url;
$post{'url_title'} = $url_title if $url_title;

my $response = LWP::UserAgent->new()->post(
	"https://api.pushover.net/1/messages.json", \%post
);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	die "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}
