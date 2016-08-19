use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

my $universo = Universo::ModernTimes->new;

my $personaje = $universo->fabricar('Personaje');

isa_ok($personaje, 'Personaje');