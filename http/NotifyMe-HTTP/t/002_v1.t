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

use strict;
use warnings;

use NotifyMe::HTTP;
use Test::More tests => 7; # Change to planned tests
use Plack::Test;
use HTTP::Request::Common;
use JSON::XS;
use Ref::Util qw<is_coderef>;
use Data::Dumper;

# Get API key
my $key = $ENV{'API_KEY'} || '';

# 1:
my $app = NotifyMe::HTTP->to_app;
ok( is_coderef($app), 'Got app' );

# 2: / » 403
my $test = Plack::Test->create($app);
my $res  = $test->request( GET "/?key=WRONGKEY" );
ok( $res->status_line =~ /^403/, '[GET /] error 403 test successful' );

# 3: / » 200
$res  = $test->request( GET "/?key=$key" );
ok( $res->is_success, '[GET /] successful [200]' );

# 4: /ptsv2 » 200
$res  = $test->request( GET "/ptsv2?key=$key" );
ok( $res->is_success, '[GET /ptsv2] successful [200]' );

# 5: /tmp.pl » 200
my $header = ['Content-Type' => 'application/json; charset=UTF-8'];
my %data = ( msg => '3.14159', title => 'TEST' );
my $encoded_data = encode_json(\%data);
my $request = POST "/v1/tmp.pl?key=$key";
$request->header( 'Content-Type' => 'application/json', 'Content-Length' => length($encoded_data) );
$request->content( $encoded_data );
$res = $test->request($request);
ok( $res->is_success, '[POST /v1/tmp.pl] successful [200]' );

# 6: Read /tmp/notiy-me-tmp-test
ok( qx{grep 'msg' /tmp/notiy-me-tmp-test} =~ /3\.14159/, '[/tmp/notiy-me-tmp-test] successful' );

# 7: /tmp.pl » 400 (JSON missing)
$res  = $test->request( POST "/v1/tmp.pl?key=$key" );
ok( $res->status_line =~ /^400/, '[POST /v1/tmp.pl] error 400 test successful' );
