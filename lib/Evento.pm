package Evento;
use JSON;
use Data::Dumper;
use fields qw(_sujeto _objeto _tipo);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		return $self;
	}

    sub sujeto {
        my $self = shift;
        my $value = shift;
        $self->{_sujeto} = $value if defined $value;
        return $self->{_sujeto};
    }


    sub objeto {
        my $self = shift;
        my $value = shift;
        $self->{_objeto} = $value if defined $value;
        return $self->{_objeto};
    }

    sub tipo {
        my $self = shift;
        my $value = shift;
        $self->{_tipo} = $value if defined $value;
        return $self->{_tipo};
    }

    sub nombre {
        my $self = shift;
        return $self->tipo->nombre;
    }

    sub texto {
        my $self = shift;
        return $self->tipo->texto;
    }

    sub verbo {
        my $self = shift;
        return $self->tipo->verbo;
    }


    sub json {
        my $self = shift;
        my $hash = {%{$self}};
        $hash->{_sujeto} = $self->sujeto->nombre;   
        $hash->{_objeto} = $self->objeto->nombre;
        $hash->{_tipo} = $self->tipo->nombre;
        return JSON::encode_json($hash);
    }

    sub descripcion {
        my $self = shift;
        return $Universo::actual->descripcion($self);
    }

1;