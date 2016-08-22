use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;

my $universo = Universo::ModernTimes->new;

{
	my $personaje1 = $universo->fabricar('Personaje',{courage=>1});
	my $personaje2 = $universo->fabricar('Personaje',{sexo=>'f',appearance => 4,courage=>2,pelo_largo=>'largo',pelo_color=>'moroch[a|o]'});
	my $evento = $universo->fabricar('Evento', {sujeto => $personaje1, objeto => $personaje2});
	is $evento, undef;

}

{
	my $personaje1 = $universo->fabricar('Personaje',{courage=>3});
	my $personaje2 = $universo->fabricar('Personaje',{sexo=>'f',appearance => 4,courage=>2,pelo_largo=>'largo',pelo_color=>'moroch[a|o]'});
	my $evento = $universo->fabricar('Evento', {sujeto => $personaje1, objeto => $personaje2});
	isa_ok $evento, 'Evento', $evento->descripcion;
}

