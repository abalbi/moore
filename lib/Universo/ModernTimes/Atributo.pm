package Universo::ModernTimes::Atributo;
use JSON;
use Data::Dumper;
use base 'Universo::Atributo';
use fields qw(_nombre _validos _tags _descripciones);

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

    sub validos {
        my $self = shift;
        my $value = shift;
        $self->{_validos} = $value if defined $value;
        return $self->{_validos};
    }

    sub tags {
        my $self = shift;
        my $value = shift;
        $self->{_tags} = $value if defined $value;
        return $self->{_tags};
    }

    sub descripciones {
        my $self = shift;
        my $value = shift;
        $self->{_descripciones} = $value if defined $value;
        return $self->{_descripciones};
    }

1;