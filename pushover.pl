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
# Send message via Pushover API (https://pushover.net/api)
#
# Help: https://github.com/Cyclenerd/notify-me


BEGIN {
	$VERSION = "1.0";
}
use utf8;
binmode(STDOUT, ":utf8");
use strict;
use LWP::UserAgent;
use App::Options (
	option => {
		user  => { required => 1, description => "The user/group key (not e-mail address) of your user" }, # viewable when logged into our dashboard
		token => { required => 1, description => "Your application's API token ", secure => 1 },
		msg   => { required => 1, description => "Your message" },
	},
);

my $response = LWP::UserAgent->new()->post(
	"https://api.pushover.net/1/messages.json", [
	"token"   => $App::options{token},
	"user"    => $App::options{user},
	"message" => $App::options{msg},
]);

if ($response->is_success) {
	print "OK: Message sent successfully.\n";
} else {
	warn "ERROR: Message could not be sent! Status: '". $response->status_line ."'\n";
}
