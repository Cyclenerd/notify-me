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

our $VERSION = '1.2.4';

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

# For PTSV2 test
get '/ptsv2' => sub {
	send_as JSON => { url => $ENV{'PTSV2_URL'} };
};

# JSON message
post qr{^/v1/([\w\d_-]+\.pl)$} => sub {
	my ($script) = splat;
	debug( "  Script: ". $script );
	if (request->body) {
		debug( qx( pwd ) );
		# Decode JSON
		debug( "  Body: ". request->body );
		# Defaults
		my $title = "";
		my $msg   = "message missing";
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
				# Icon
				my $icon = '➡️';
				$icon = '🔥' if $state eq 'open';
				$icon = '✅' if $state eq 'closed';
				$icon = '🔕' if $state eq 'test';
				# Edit state (uppercase)
				$state = uc $state;
				# Edit resource name
				$resource_name =~ s/\{/\[/g;
				$resource_name =~ s/\}/\]/g;
				# Message
				$msg = "$icon [$state] $policy_name » $resource_name";
			}
			# Random filename for mesage, title and output
			my $digest     = sha256_hex( time()+rand(10000) );
			my $file_out   = '/tmp/'.$digest.'.out';
			my $file_msg   = '/tmp/'.$digest.'.msg';
			my $file_title = '/tmp/'.$digest.'.title';
			debug( "  Digest: " .$digest );
			# Save message
			debug( "  Msg: " .$msg );
			open(MSG, '>:utf8', $file_msg);
			print MSG "$msg";
			close MSG;
			# Save title
			debug( "  Title: " .$title );
			open(TITLE, '>:utf8', $file_title);
			print TITLE "$title";
			close TITLE;
			# Run command line Perl script and redirect output
			my $perl_script = qx{ perl $script --msg="\$\( head -1 $file_msg \)" --title="\$\( head -1 $file_title \)" > $file_out 2>&1 };
			# Read output (STDOUT and STDERR)
			open my $fh, "<$file_out";
			sysread $fh, my $file_content, 1000;
			close $fh;
			 # Delete files
			unlink($file_out);
			unlink($file_msg);
			unlink($file_title);
			# Check output
			debug(  "File content: " .$file_content );
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
