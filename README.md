# PerlFastCache

##	DESCRIPTION: 

	Use the object memory in a persistant environment. 
	Ttl allows the object cache to expire. 


##	EXAMPLE: 

	my $fast = Fast->new();
	
	my $data = { 
	        1 => 'One',
	        2 => 'Two',
	        3 => 'Three'
	};
	
	$fast->init( set => 1, token => 'uniq-group', mem_key => 'mem', ttl => 300, value => $data );
	my $res = $fast->init( token => 'uniq-group', mem_key => 'mem', ttl => 300 );
	
	print Dumper( $res );
