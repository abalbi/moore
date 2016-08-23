package ModernTimes::EventoBuilder;
use strict;
use Data::Dumper;
use fields qw(_sujeto);

our $actual;

	sub new {
		my $self = shift;
		$self = fields::new($self);
		$Moore::logger->info('Se instacion un nuevo ', ref($self));
		return $self;
	}

    sub build {
        my $self = shift;
        my $evento = shift;
        my $tipo = Universo::actual->evento('CHANTAJE');
        $evento->tipo($tipo);
        my @validaciones = ();
        if(!$evento->sujeto) {
            $Moore::logger->trace('El evento ', $evento->nombre, ' genera automaticamente un personaje');
            my $sujeto = Universo::actual->fabricar('Personaje', $evento->tipo->sujeto) ;
            $evento->sujeto($sujeto);
        }
        if(!$evento->objeto) {
            $Moore::logger->trace('El evento ', $evento->nombre, ' genera automaticamente un personaje');
            my $objeto = Universo::actual->fabricar('Personaje', $evento->tipo->objeto) ;
            $evento->objeto($objeto);
        }
        push @validaciones, $self->validar_rol($evento, 'sujeto');
        push @validaciones, $self->validar_rol($evento, 'objeto');
        return undef if scalar grep {$_ == 0} @validaciones;
        return $evento;
    }

    sub validar_rol {
        my $self = shift;
        my $evento = shift;
        my $rol = shift;
        my $personaje = $evento->$rol;
        foreach my $key (keys %{$evento->tipo->$rol}) {
            my $rango = $evento->tipo->$rol->{$key};
            if(scalar grep {$personaje->$key == $_} @$rango) {
                $Moore::logger->trace($personaje->nombre, ' tiene ', $key ,' a ',$personaje->$key ,' y esta en el rango [', join(',',@$rango),'] del ', $rol, ' de un ',$evento->tipo->nombre);
            } else {
                $Moore::logger->trace($personaje->nombre, ' tiene ', $key ,' a ',$personaje->$key ,' y NO esta en el rango [', join(',',@$rango),'] del ', $rol, ' de un ',$evento->tipo->nombre);
                return 0;
            }
        }
        return 1
    }

    sub sujeto {
        my $self = shift;
        my $sujeto = shift;
        $self->{_sujeto} = $sujeto if defined $sujeto;
        return $self->{_sujeto};    
    }
1;