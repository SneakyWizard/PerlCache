package Fast;

=head2

	DESCRIPTION: 

		Use the object memory in a persistant environment. 
		Ttl allows the object cache to expire. 
	

	EXAMPLE: 

		my $fast = Fast->new();

		my $data = { 
			1 => 'One',
			2 => 'Two',
			3 => 'Three'
		};

		$fast->init( set => 1, token => 'uniq-group', mem_key => 'mem', ttl => 300, value => $data );
		my $res = $fast->init( token => 'uniq-group', mem_key => 'mem', ttl => 300 );

		print Dumper( $res );

=cut 

use strict;

sub new {
	return bless {}, $_[0];
}

sub init {
	my ( $self, %args ) = @_;

	my $ttl     = $args{ttl}   || 10;
	my $value   = $args{value};
	my $token   = $args{token} || 'FAST';
	my $mem_key = $args{mem_key};

	my $result;

	if ( $mem_key ) {

		my $set = 0;
		
		if ( ref $value eq 'HASH' && %$value ) { 
			$set = 1;	
		} elsif ( ref $value eq 'ARRAY' && @$value ) { 
			$set = 1;	
		} elsif ( length $value ) {
			$set = 1;	
		}
		
		# Set or get.
		if ( $set ) {

			if ( $token ) { 
				$self->{ $token }{ $mem_key }{ttl}   = $ttl;
				$self->{ $token }{ $mem_key }{time}  = time();
				$self->{ $token }{ $mem_key }{value} = $value;
			} else { 
				$self->{ $mem_key }{ttl}   = $ttl;
				$self->{ $mem_key }{time}  = time();
				$self->{ $mem_key }{value} = $value;
			}

		} else {

			my $time1 = time();
			my $cur   = 0;
			my $pttl  = 0;

			if ( $token ) { 
				my $time2 = $self->{ $token }{ $mem_key }{time};
				$pttl     = $self->{ $token }{ $mem_key }{ttl};
				$cur      = $time1 - $time2 if $time2;
				$result   = $self->{ $token }{ $mem_key }{value};
			} else { 
				my $time2 = $self->{ $mem_key }{time};
				$pttl     = $self->{ $mem_key }{ttl};
				$cur      = $time1 - $time2 if $time2;
				$result   = $self->{ $mem_key }{value};
			}

			# Clear when ttl is up.
			if ( $cur && $cur >= $pttl ) { 
				$self->{ $mem_key }           = {};
				$self->{ $token }{ $mem_key } = {};
			}

		}
	}

	return $result;
}

1;
