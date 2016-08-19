use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

Universo::ModernTimes->new;
my $personaje = $Universo::actual->fabricar('Personaje', {strengh => 5, charisma => 5, perception => 2, instinct => 1});

is($personaje->strengh, 5, 'Fijo fuerza con valor fijo');
is($personaje->instinct, 1, 'Fijo instinct con valor fijo');