use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;
use Data::Dumper;

my $universo = Universo::ModernTimes->new;

{
	my $builder = Universo::ModernTimes::PersonajeBuilder->new;
	my $personaje = Personaje->new;
	$builder->personaje($personaje);

	my $atributos = Universo::actual->atributo('social');
	$builder->asignar_puntos_random($atributos,10);

	is($personaje->charisma,2);
	is($personaje->manipulation,4);
	is($personaje->appearance,4);
	
}

{
	my $builder = Universo::ModernTimes::PersonajeBuilder->new;
	my $personaje = Personaje->new;
	$personaje->appearance(4);
	$builder->personaje($personaje);

	my $atributos = Universo::actual->atributo('social');
	my $filtrados = [];
	$builder->filtrados_y_defaults($atributos,$filtrados);

	is $filtrados->[0], 'appearance';
	is($personaje->charisma,1);
	is($personaje->manipulation,1);
	is($personaje->appearance,4);
	
}


{
	my $builder = Universo::ModernTimes::PersonajeBuilder->new;
	my $personaje = Personaje->new;
	$builder->personaje($personaje);
	my $estructura = {};
	$builder->estructura_tag($estructura, 'social', [10,8,6]);
	$builder->estructura_tag($estructura, 'physical', [10,8,6]);
	$builder->estructura_tag($estructura, 'mental', [10,8,6]);

	is $estructura->{social}->{min}, 3; 
	is $estructura->{social}->{tag}, 'social';
	is $estructura->{social}->{posibles_puntos}->[0], 10; 
	is $estructura->{social}->{posibles_puntos}->[1], 8;
	is $estructura->{social}->{posibles_puntos}->[2], 6;
	is $estructura->{social}->{atributos}->[0]->{nombre}, 'manipulation';
	is $estructura->{social}->{atributos}->[1]->{nombre}, 'appearance';
	is $estructura->{social}->{atributos}->[2]->{nombre}, 'charisma';

	$builder->estructura_validar($estructura,[10,8,6]);

	is $estructura->{social}->{min}, 3; 
	is $estructura->{social}->{tag}, 'social';
	is $estructura->{social}->{posibles_puntos}->[0], 10; 
	is $estructura->{social}->{posibles_puntos}->[1], 8;
	is $estructura->{social}->{posibles_puntos}->[2], 6;
	is $estructura->{social}->{atributos}->[0]->{nombre}, 'manipulation';
	is $estructura->{social}->{atributos}->[1]->{nombre}, 'appearance';
	is $estructura->{social}->{atributos}->[2]->{nombre}, 'charisma';

	$builder->estructura_puntos_asignados($estructura,[10,8,6]);

	is $estructura->{social}->{min}, 3; 
	is $estructura->{social}->{tag}, 'social';
	is $estructura->{social}->{posibles_puntos}->[0], 10; 
	is $estructura->{social}->{posibles_puntos}->[1], 8;
	is $estructura->{social}->{posibles_puntos}->[2], 6;
	is $estructura->{social}->{atributos}->[0]->{nombre}, 'manipulation';
	is $estructura->{social}->{atributos}->[1]->{nombre}, 'appearance';
	is $estructura->{social}->{atributos}->[2]->{nombre}, 'charisma';

	is $estructura->{physical}->{puntos_asignados}, 8; 
	is $estructura->{social}->{puntos_asignados}, 10; 
	is $estructura->{mental}->{puntos_asignados}, 6; 


}