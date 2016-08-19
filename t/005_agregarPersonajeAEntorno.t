use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

Universo::ModernTimes->new;
my $personaje = $Universo::actual->fabricar('Personaje');

Entorno->instancia->agregar($personaje);

is(Entorno->instancia->personaje($personaje->nombre), $personaje, 'Se puede acceder al personaje');