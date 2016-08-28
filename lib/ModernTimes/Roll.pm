package ModernTimes::Roll;
use strict;
use Data::Dumper;
use fields qw(_resultado _dados _dados_mod _dif _dif_mod);

	sub new {
		my $self = shift;
		my $args = shift;
		$self = fields::new($self);
		$self->{_resultado} = [];
		$self->{_dados} = $args->{dados};
		$self->{_dados_mod} = $args->{dados_mod};
		$self->{_dif} = $args->{dif}?$args->{dif}:6;
		$self->{_dif_mod} = $args->{dif_mod};
		return $self;
	}

	sub roll {
		my $self = shift;
        push @{$self->{_resultado}}, (int(rand(10)) + 1) for (1..($self->{_dados} + $self->{_dados_mod}));
        $Moore::logger->trace($self->descripcion);
        return $self;
	}

	sub descripcion {
		my $self = shift;
		my $str = $self->exitos > 0 ? 'EXITO' : $self->exitos == 0 ? 'FALLO' : 'PIFIA';
		$str .= ': '.$self->exitos.' ['.join(' ', @{$self->resultado}).'] - dif:'.$self->dificultad;
		return $str;
	}

	sub es_pifia {
		my $self = shift;
		return $self->exitos < 0;
	}

	sub es_exito {
		my $self = shift;
		return $self->exitos > 0;
	}

	sub es_fallo {
		my $self = shift;
		return $self->exitos == 0;
	}

	sub resultado {
		my $self = shift;
		return $self->{_resultado};
	}

	sub exitos_puros {
		my $self = shift;
		return scalar grep {$_ >= $self->dificultad} @{$self->{_resultado}};
	}

	sub pifias {
		my $self = shift;
		return scalar grep {$_ == 1} @{$self->{_resultado}};
	}

	sub dificultad {
		my $self = shift;
		return $self->{_dif} + $self->{_dif_mod}
	}

	sub exitos {
		my $self = shift;
		return $self->exitos_puros - $self->pifias;
	}
1;