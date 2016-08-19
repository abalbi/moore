use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;


BEGIN { use_ok('Personaje') };

require_ok( 'Personaje' );

my $personaje = new Personaje();

isa_ok($personaje, 'Personaje');
