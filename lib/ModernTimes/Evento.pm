package ModernTimes::Evento;
use JSON;
use Data::Dumper;
use base 'Universo::Evento';
use fields qw(_nombre _tags _objeto _texto _sujeto _verbo);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		$self->{_tags} = [];
		return $self;
	}

	sub hacer {
		my $class = shift;
		my $args = shift;
		my $obj = __PACKAGE__->new();
		foreach my $arg (keys %$args) {
			$obj->$arg($args->{$arg});
		}
		return $obj;
	}

    sub nombre {
        my $self = shift;
        my $value = shift;
        $self->{_nombre} = $value if defined $value;
        return $self->{_nombre};
    }

    sub objeto {
        my $self = shift;
        my $value = shift;
        $self->{_objeto} = $value if defined $value;
        return $self->{_objeto};
    }

    sub sujeto {
        my $self = shift;
        my $value = shift;
        $self->{_sujeto} = $value if defined $value;
        return $self->{_sujeto};
    }

    sub texto {
        my $self = shift;
        my $value = shift;
        $self->{_texto} = $value if defined $value;
        return $self->{_texto};
    }

    sub verbo {
        my $self = shift;
        my $value = shift;
        $self->{_verbo} = $value if defined $value;
        return $self->{_verbo};
    }


    sub tags {
        my $self = shift;
        my $value = shift;
        $self->{_tags} = $value if defined $value;
        return [@{$self->{_tags}},$self->nombre];
    }

1;