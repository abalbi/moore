package Moore;

use Data::Dumper;
use Log::Log4perl;
Log::Log4perl->init("log.conf");
$Moore::logger = Log::Log4perl->get_logger("runner");
@EXPORT = qw(aleatorio);


$Moore::semilla = 3;
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
    $Moore::logger->debug($resultado);
    $resultado =~ s/\[(.+)\]//;
    my @letras = split(/\|/, $1) if $1;
    $resultado = $resultado . $letras[0] if $letras[0] && $personaje->sexo eq 'f';
    $resultado = $resultado . $letras[1] if $letras[1] && $personaje->sexo eq 'm';
    $resultado =~ s/_/ /gi;
    return $resultado;
}

sub mezclar {
	my $class = shift;
	my @orig = @_;
	my @dest = ();
	my $orig = $#orig;
	$Data::Dumper::Maxdepth = 3;
	push @dest, undef for (0..$orig);
	while (1) {
		print STDERR Dumper [$orig, [@orig],$i,[@dest]];
		my $i = int(rand($orig));
		my $item = shift @orig;
		$dest[$i] = $item;
		$dest = $#dest;
		print STDERR Dumper [$orig, [@orig],$i,[@dest]];
		next if $orig != $dest;
		last;
	}
}

1;