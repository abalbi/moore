package Moore;

use Data::Dumper;
use Log::Log4perl;
use Log::Log4perl::Level;
Log::Log4perl->init("log.conf");
$Moore::logger = Log::Log4perl->get_logger("runner");
@EXPORT = qw(aleatorio);


$Moore::semilla = 3;
srand($Moore::semilla);

use Entorno;
use Personaje;
use Evento;
use Universo;
use ModernTimes;


sub runner {
    my $args = shift;
    srand($Moore::semilla);
    my $universo = $args->{universo};
    my $personaje = $args->{personaje};
    my $log = $args->{log};
    $loglevel = $OFF;
    $loglevel = $OFF if $log eq 'OFF';
    $loglevel = $FATAL if $log eq 'FATAL';
    $loglevel = $ERROR if $log eq 'ERROR';
    $loglevel = $WARN if $log eq 'WARN';
    $loglevel = $INFO if $log eq 'INFO';
    $loglevel = $DEBUG if $log eq 'DEBUG';
    $loglevel = $TRACE if $log eq 'TRACE';
    $loglevel = $ALL if $log eq 'ALL';
    $Moore::logger->level( $loglevel );
    $universo->new;
    if($personaje) {
        foreach (1..$personaje) {
            my $per = Entorno->instancia->agregar($Universo::actual->fabricar('Personaje'));
            print $per->descripcion."\n";
        }
    }
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
    $Moore::logger->trace('t: ',$string, ' -> ', $resultado);
    return $resultado;
}

1;