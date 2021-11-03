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
# Help: https://github.com/Cyclenerd/notify-me

package NotifyMe::HTTP;
use Dancer2;
use Digest::SHA qw(sha256_hex);

our $VERSION = '1.1.0';

# AUTHENTICATION
hook before_request => sub {
	my $key = param('key') || "";
	debug( "API key: $key" );
	debug( "Env API key: ". $ENV{'API_KEY'} );
	if ( $ENV{'API_KEY'} && $key eq $ENV{'API_KEY'} ) {
		return;
	} else {
		response->status(403);
		send_as JSON => { error => "API key" };
	}
};

# Root
get '/' => sub {
	send_as JSON => { version => "$VERSION" };
};

# JSON message
post qr{/v1/([\w\d_-]+\.pl)} => sub {
	my ($script) = splat;
	if (request->body) {
		debug( qx( pwd ) );
		# Decode JSON
		debug( request->body );
		# Defaults
		my $title = "";
		my $msg = "msg missing";
		# Read JSON
		my $json = decode_json( request->body );
		if ($json) {
			# Read JSON
			$title = $json->{title} if ($json->{title});
			$msg   = $json->{msg}   if ($json->{msg});
			# Read Google Monitoring JSON message
			if ($json->{incident}) {
				my $resource_name  = $json->{incident}->{resource_name}  || 'resource name missing';
				my $state          = $json->{incident}->{state}          || '???';
				my $policy_name    = $json->{incident}->{policy_name}    || 'policy name missing';
				my $condition_name = $json->{incident}->{condition_name} || 'condition name missing';
				my $summary        = $json->{incident}->{summary}        || 'summary missing';
				my $icon = $state eq 'open' ? '🔥' : '✅';
				# Message
				$title = "$icon [$state] $policy_name : $resource_name";
				$msg  = "$summary";
			}
			# Random filename for output
			my $digest   = sha256_hex( time()+rand(10000) );
			my $filename = '/tmp/notify-me-'.$digest.'.txt';
			# Run command line Per script and redirect output
			my $perl_script = qx(perl \"$script\" --msg=\"$msg\" --title=\"$title\" > $filename 2>&1);
			# Read output (STDOUT and STDERR)
			open(FH, '<', $filename);
			my $file_content = '';
			while (<FH>) {
				$file_content .= $_;
			}
			# Check output
			if ( $file_content =~ /OK/ ) {
				response->status(200);
				send_as JSON => { ok => "Message sent successfully" };
			} else {
				response->status(502);
				send_as JSON => { error => "Message could not be sent!", output => $file_content };
			}
		} else {
			response->status(406);
			send_as JSON => { error => "Could not read JSON" };
		}
	} else {
		response->status(400);
		send_as JSON => { error => "JSON missing" };
	}
};

true;
