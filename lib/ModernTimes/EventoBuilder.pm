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
        my $boo = 1;
        foreach my $key (keys %{$evento->tipo->{sujeto_ideal}}) {
            my $rango = $evento->tipo->{sujeto_ideal}->{$key};
            if(scalar grep {$evento->sujeto->$key == $_} @$rango) {
                $Moore::logger->trace($evento->sujeto->nombre, ' tiene el ', $key ,' suficiente para ser sujeto ',$evento->tipo->{nombre});
            } else {
                $boo = 0;
                $Moore::logger->trace($evento->sujeto->nombre, ' NO tiene el ', $key ,' suficiente para ser sujeto ',$evento->tipo->{nombre});
            }
        }
        foreach my $key (keys %{$evento->tipo->{objeto_ideal}}) {
            my $rango = $evento->tipo->{objeto_ideal}->{$key};
            if(scalar grep {$evento->objeto->$key == $_} @$rango) {
                $Moore::logger->trace($evento->objeto->nombre, ' tiene el ', $key ,' suficiente para ser objeto ',$evento->tipo->{nombre});
            } else {
                $boo = 0;
                $Moore::logger->trace($evento->objeto->nombre, ' NO tiene el ', $key ,' suficiente para ser objeto ',$evento->tipo->{nombre});
            }
        }
        return $evento if $boo;
        return undef;
    }

    sub sujeto {
        my $self = shift;
        my $sujeto = shift;
        $self->{_sujeto} = $sujeto if defined $sujeto;
        return $self->{_sujeto};    
    }
1;