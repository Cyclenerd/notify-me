#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use NotifyMe::HTTP;

NotifyMe::HTTP->to_app;