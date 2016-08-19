package Moore;

use Log::Log4perl;
Log::Log4perl->init("log.conf");
$Moore::logger = Log::Log4perl->get_logger("runner");
@EXPORT = qw(aleatorio);


$Moore::semilla = 9815425;
srand($Moore::semilla);

use Entorno;
use Personaje;
use Universo;
use Universo::ModernTimes;


sub runner {

}


sub t {
	my $class = shift;
    my $personaje = shift;
    my $string = shift;
    my $resultado = $string;
    $resultado =~ s/\[(.+)\]//;
    my @letras = split(/\|/, $1) if $1;
    $resultado = $resultado . $letras[0] if $letras[0] && $personaje->sexo eq 'f';
    $resultado = $resultado . $letras[1] if $letras[1] && $personaje->sexo eq 'm';
    $resultado =~ s/_/ /gi;
    return $resultado;
}

1;