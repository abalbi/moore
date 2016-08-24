use lib 'lib';
use Moore;
use Getopt::Long;

my $srand = 3;
my $personaje = 0;
my $universo = 'ModernTimes';
my $log = 'OFF';

GetOptions(
	'srand=i' => \$srand,
	'personaje=i' => \$personaje,
	'universo=s' => \$universo,
	'log=s' => \$log,
);

$Moore::semilla = $srand;

Moore::runner({
	personaje => $personaje,
	universo => $universo,
	log => $log,
});