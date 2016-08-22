use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;


my $universo = Universo::ModernTimes->new;

my $personaje = $universo->fabricar('Personaje', { sexo=>'f', appearance=>5, perception=>5});

is($personaje->appearance,5);
