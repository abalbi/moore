use strict;
use warnings;
use Test::More qw(no_plan);
use lib 'lib';
use Moore;
use Text::Levenshtein(qw(distance));
use Data::Dumper;

my $universo = ModernTimes->new;

{
	my $personaje1 = $universo->fabricar('Personaje',{appearance=>4,subterfuge=>4});
	my $personaje2 = $universo->fabricar('Personaje',{appearance=>4,wits=>1});
	print $personaje1->descripcion."\n";
	print $personaje2->descripcion."\n";

	my $personaje2_se_va = 0;

	my $roll = {}; 
	$roll = {
		dados => $personaje1->appearance + $personaje1->subterfuge,
		dif => $personaje2->wits,
		dif_mod => + 3
	};
	$roll = ModernTimes::roll($roll);
	my @str;
	push @str, $personaje1->nombre; 
	push @str, 'aborda';
	push @str, $personaje2->nombre;
	$str[$#str] .= '.';
	push @str, $personaje2->t('Est[a|e]');
	push @str, $personaje2->t('siente ofendid[a|o]') if $roll->es_pifia;
	$personaje2_se_va = 1 if $roll->es_pifia;
	push @str, $personaje2->t('esta molest[a|o]') if $roll->es_fallo;
	if($roll->es_exito){
		push @str, $personaje2->t('esta interesad[a|o]') if $roll->exitos == 1;
		push @str, $personaje2->t('sonrie halagad[a|o]') if $roll->exitos == 2;
		push @str, $personaje2->t('queda sorprendid[a|o]') if $roll->exitos == 3;
		push @str, $personaje2->t('queda fasinada[a|o]') if $roll->exitos > 3;	
	}
	$str[$#str] .= '.';

	if(!$personaje2_se_va) {
		my $dados_mod = $roll->exitos - 1 > 0 ? $roll->exitos - 1 : 0;
		$roll = {
			dados => $personaje1->wits + $personaje1->subterfuge,
			dados_mod => $dados_mod,
			dif => $personaje2->intelligence,
			dif_mod => +3
		};
		$roll = ModernTimes::roll($roll);

		push @str, 'Entonces,';
		push @str, $personaje1->nombre;
		push @str, 'empieza una charla casual a la que';
		push @str, $personaje2->nombre;
		push @str, 'responde';
		push @str, $personaje2->t('ofendid[a|o]') if $roll->es_pifia;
		$personaje2_se_va = 1 if $roll->es_pifia;
		push @str, $personaje2->t('molest[a|o]') if $roll->es_fallo;
		if($roll->es_exito){
			push @str, $personaje2->t('interesad[a|o]') if $roll->exitos == 1;
			push @str, $personaje2->t('halagad[a|o]') if $roll->exitos == 2;
			push @str, $personaje2->t('alegremente sorprendid[a|o]') if $roll->exitos == 3;
			push @str, $personaje2->t('fasinad[a|o]') if $roll->exitos > 3;	
		}
		$str[$#str] .= '.';
		if(!$personaje2_se_va) {

			$dados_mod = $roll->exitos - 1 > 0 ? $roll->exitos - 1 : 0;
			$roll = {
				dados => $personaje1->charisma + $personaje1->empathy,
				dados_mod => $dados_mod,
				dif => $personaje2->perception,
				dif_mod => +3
			};
			$roll = ModernTimes::roll($roll);

			push @str, 'Entonces,';
			push @str, $personaje1->nombre;
			push @str, 'empieza a dejar claras sus intenciones con';
			push @str, $personaje2->nombre;
			push @str, 'que entonces';
			push @str, $personaje2->t('se ofende') if $roll->es_pifia;
			$personaje2_se_va = 1 if $roll->es_pifia;
			push @str, $personaje2->t('se molesta y declina') if $roll->es_fallo;
			if($roll->es_exito){
				push @str, $personaje2->t('se muestra dispuest[a|o]') if $roll->exitos == 1;
				push @str, $personaje2->t('se entrega') if $roll->exitos == 2;
				push @str, $personaje2->t('se muestra desesperada') if $roll->exitos == 3;
				push @str, $personaje2->t('se entrega por completo') if $roll->exitos > 3;	
			}
			$str[$#str] .= '.';

	    } else {
			push @str, "\n";
	    	push @str, $personaje2->nombre;
			push @str, 'se va';
			$str[$#str] .= '.';
		}
	} else {
		push @str, "\n";
    	push @str, $personaje2->nombre;
		push @str, 'se va';
		$str[$#str] .= '.';

    }
	print (join(" ",@str));


}



