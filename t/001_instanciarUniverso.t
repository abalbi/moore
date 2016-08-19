use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

#unlink('myerrs.log');

BEGIN { use_ok('Universo') };

require_ok( 'Universo' );

isa_ok(new Universo(), 'Universo');

my $universo = new Universo::ModernTimes;

isa_ok($universo, 'Universo');
isa_ok($universo, 'Universo::ModernTimes');


isa_ok (Universo::actual(), 'Universo::ModernTimes');
isa_ok (Universo->actual, 'Universo::ModernTimes');
isa_ok ($Universo::actual, 'Universo::ModernTimes');