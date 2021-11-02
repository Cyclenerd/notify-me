#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";


# use this block if you don't need middleware, and only have a single target Dancer app to run here
use NotifyMe::HTTP;

NotifyMe::HTTP->to_app;

=begin comment
# use this block if you want to include middleware such as Plack::Middleware::Deflater

use NotifyMe::HTTP;
use Plack::Builder;

builder {
    enable 'Deflater';
    NotifyMe::HTTP->to_app;
}

=end comment

=cut

=begin comment
# use this block if you want to mount several applications on different path

use NotifyMe::HTTP;
use NotifyMe::HTTP_admin;

use Plack::Builder;

builder {
    mount '/'      => NotifyMe::HTTP->to_app;
    mount '/admin'      => NotifyMe::HTTP_admin->to_app;
}

=end comment

=cut

