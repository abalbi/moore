package Entorno;

use strict;
use Data::Dumper;
use fields qw(_personajes);

our $instancia;

	sub new {
		my $self = shift;
		$self = fields::new($self);
		return $self;
	}

	sub instancia {
		my $class = shift;
		if(!$instancia) {
			$instancia = Entorno->new if !$instancia;
			$Moore::logger->info('Se instancio un nuevo Entorno');
		}
		return $instancia;
	}

	sub agregar {
		my $self = shift;
		my $item = shift;
		if(ref($item) eq 'Personaje') {
			$self->personajes->{$item->nombre} = $item;
			$Moore::logger->trace('Se agrego a ', $item->json);
		}
	}

	sub personajes {
		my $self = shift;
		$self->{_personajes} = {} if !$self->{_personajes};
		return $self->{_personajes};
	}

	sub personaje {
		my $self = shift;
		my $nombre = shift;
		return $self->{_personajes}->{$nombre};		
	}
1;