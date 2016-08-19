use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

my $entorno = Entorno->instancia;

isa_ok($entorno, 'Entorno');

is($entorno, Entorno->instancia, 'Always the same instance');
