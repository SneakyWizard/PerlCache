#!/usr/bin/perl -w 

use Data::Dumper;
use lib qw(.);
use strict;
use Fast;

my $fast = Fast->new();

my $data = { 
	1 => 'One',
	2 => 'Two',
	3 => 'Three'
};

$fast->init( set => 1, token => 'uniq-group', mem_key => 'mem', ttl => 300, value => $data );
my $res = $fast->init( token => 'uniq-group', mem_key => 'mem', ttl => 300 );

print Dumper( $res );
