package Universo;

use strict;
use Data::Dumper;
use fields qw(_atributos _builder);

our $actual;

	sub new {
		my $self = shift;
		$self = fields::new($self);
		$Moore::logger->info('Se instacion un nuevo ', ref($self));
		$actual = $self;
		$self->hacer_atributos;
		return $self;
	}

	sub fabricar {
		my $self = shift;
		my $class = shift;
		my $args = shift;
		$Moore::logger->info('Se instacion un nuevo ', $class);
		my $obj = $class->new($args);
		return $obj;
	}

	sub actual {
		my $class = shift;
		return $actual;
	}

	sub atributos {
		my $self = shift;
		return $self->{_atributos};
	}

	sub atributo {
		my $self = shift;
		my $tag = shift;
		my $arr = [];
		foreach my $atributo (@{$self->{_atributos}}) {
			push @$arr, $atributo if grep {$_ eq $tag} @{$atributo->{tags}};
		}
		return $arr->[0] if scalar(@$arr) == 1;
		return $arr;
	}

	sub builder {
		my $self = shift;
		my $builder = shift;
		$self->{_builder} = $builder if defined $builder;
		return $self->{_builder};
	}

	sub atributos_nombres {
		my $self = shift;
		return map {$_->{nombre}} @{$self->{_atributos}};
	}

	sub hacer_atributos {

	}
1;