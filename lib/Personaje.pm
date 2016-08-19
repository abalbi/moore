package Personaje;
use JSON;
use Data::Dumper;
use fields qw(_atributo);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		return $self;
	}

	sub AUTOLOAD {
	    my $method = $AUTOLOAD;
	    my $self = shift;
	    $method =~ s/.*:://;
	    my $atributo = $method if grep {$_->{nombre} eq $method} @{Universo->actual->atributos};
	    if($atributo) {
            return $self->atributo($atributo,@_);
	    }
	    die "No existe el metodo o atributo '$method'";
    }

    sub sum {
        my $self = shift;
        my $atributos = shift;
        my $sum = 0;
        foreach my $atributo (@{$atributos}) {
            my $nombre;
            $nombre = $atributo if !ref($atributo);
            $nombre = $atributo->{nombre} if ref($atributo) eq 'HASH';
            $sum += $self->$nombre();
        }
        return $sum;
    }

    sub descripcion {
        my $self = shift;
        return $Universo::actual->descripcion($self);
    }

    sub atributo {
        my $self = shift;
        my $nombre = shift;
        my $valor = shift;
        if (defined $valor) {
        	my $valores = {};
        	if(ref($valor) eq 'HASH') {
        		foreach my $key (keys %{$valor}) {
        			$valores->{$key} = $valor->{$key};
        		}
    		} else {
    			$valores->{$nombre} = $valor;
    		}
    		foreach my $key (keys %{$valores}) {
    			my $valor = $valores->{$key};
            	$self->{_atributo}->{$key} = $valor;
            	$Moore::logger->trace(sprintf("$nombre: Se asigno %s al atributo %s para %s", $valor, $key, $self->nombre ? $self->nombre : 'NONAME'));
    		}
        }
        return $self->{_atributo}->{$nombre};
    }

	sub json {
		my $self = shift;
		return JSON::encode_json({%{$self}});
	}

1;