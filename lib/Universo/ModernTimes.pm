package Universo::ModernTimes;
use base 'Universo';
use Universo::ModernTimes::PersonajeBuilder;
use Data::Dumper;
use JSON;
use List::Util qw(shuffle);
use List::MoreUtils qw(zip);


	sub hacer_atributos {
		my $self = shift;
		push @{$self->{_atributos}}, { nombre => 'sexo' };
        push @{$self->{_atributos}}, { nombre => 'nombre'   };
        push @{$self->{_atributos}}, { nombre => 'edad'   };
        push @{$self->{_atributos}}, { nombre => 'pelo_color'   };
        push @{$self->{_atributos}}, { nombre => 'pelo_largo'   };
        push @{$self->{_atributos}}, { nombre => 'pelo_forma'   };
        push @{$self->{_atributos}}, map { 
            {
                nombre => $_,
                validos => [1..5],
                tags => [$_, qw(virtue)],
                descripciones => 
                    $_ eq 'conviction' ? {1 => 'estable', 2 => 'determinad[a|o]', 3 => 'impulsiv[a|o]', 4 => 'brutal', 5 => 'completamente segur[a|o]'} :
                    $_ eq 'instinct' ? {1 => 'intuitiv[a|o]', 2 => 'feral', 3 => 'bestial', 4 => 'visceral', 5 => 'primari[a|o]'} :
                    {1 => 'cobarde', 2 => 'precavid[a|o]', 3 => 'brav[a|o]', 4 => 'resuelt[a|o]', 5 => 'heroic[a|o]'}

            } 
        } qw(conviction instinct courage);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [1..5], tags => [$_, qw(attribute, physical)]} } qw(strengh dexterity stamina);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [1..5], tags => [$_, qw(attribute, social)]} } qw(manipulation appearance charisma);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [1..5], tags => [$_, qw(attribute, mental)]} } qw(intelligence perception wits);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [0..5], tags => [$_, qw(ability, talent)]} } qw(athletics brawl dodge empathy expression intimidation leadership streetwise subterfuge);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [0..5], tags => [$_, qw(ability, skill)]} } qw(animal_ken crafts drive etiquette firearms melee performance security stealth survival);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [0..5], tags => [$_, qw(ability, knowledge)]} } qw(academics bureaucracy computer finance investigation law linguistics medicine occult politics research science);
        push @{$self->{_atributos}}, map { {nombre => $_, validos => [0..5], tags => [$_, qw(background)]} } qw(allies contacts fame influence mentor resources status);
        $self->builder(Universo::ModernTimes::PersonajeBuilder->new);
        $Moore::logger->trace("Se cargaron los atributo: ", join(',',map {$_->{nombre}} @{$self->{_atributos}}));
	}

    sub descripcion {
        my $self = shift;
        my $personaje = shift;
        my $str = '';
        $str .= sprintf "%s",$personaje->nombre;
        $str .= sprintf " es %s", $personaje->sexo eq 'f' ? 'una mujer' : 'un hombre';
        $str .= sprintf " de %d", $personaje->edad;
        $str .= sprintf ".";
        $str .= sprintf " Es de una belleza %s", {1 => 'pobre', 2 => 'normal', 3 => 'buena', 4 => 'excepcional', 5 => 'deslumbrante'}->{$personaje->appearance};
        $str .= sprintf ".";
        $str .= sprintf " Es %s", Moore->t($personaje, $personaje->pelo_color);
        $str .= sprintf " y lleva el pelo %s %s", Moore->t($personaje, $personaje->pelo_forma), Moore->t($personaje, $personaje->pelo_largo);
        $str .= sprintf ".";
        $str .= sprintf " Es %s(conviction:%s)", 
            Moore->t($personaje, Moore->t($personaje, Universo::actual->atributo('conviction')->{descripciones}->{$personaje->conviction})),
            $personaje->conviction
        ;
        $str .= sprintf ", %s(instinct:%s)", 
            Universo::actual->atributo('instinct')->{descripciones}->{$personaje->instinct},
            $personaje->instinct
        ;
        $str .= sprintf " y %s(courage:%s)", 
            Moore->t($personaje, Universo::actual->atributo('courage')->{descripciones}->{$personaje->courage}),
            $personaje->courage
        ;
        return $str;
    }

	sub distribuir_validando {
        my $personaje = shift;
        my $puntos = shift;
        my $rango = shift;
    		my $atributos = [@_];
        my $hash = {};
        foreach my $key (@{$atributos}) {
          $hash->{$key} = $personaje->$key;
        }
        while(1) {
        	$hash = distribuir($puntos, $atributos);
        	if(!validar($hash, $atributos, $rango)) {
        		next;
        	}
        	last;
        }
        return $hash;
	}

    sub distribuir {
        my $puntos = shift;
        my $atributos = shift;
        my $hash = {};
        while(1) {
          my $key = [shuffle(@$atributos)]->[0];
          $hash->{$key} = $hash->{$key} + 1;
          $puntos--;
          next if $puntos;
          last;
        }
        return $hash;
    }

	sub validar {
        my $valores = shift;
        my $atributos = shift;
		my $rango = shift;
        foreach my $key (@{$atributos}) {
			my $valor = $valores->{$key};
			if (!(grep {$valor == $_} @$rango)) {
		    $Moore::logger->trace("El valor '$valor' esta fuera del rango [", join(',', @$rango),"] para ", $key);
				return 0;
			} 
		}
		return 1;
	}



	sub fabricar {
		my $self = shift;
        my $class = shift;
        my $args = shift;
		my $obj = $self->SUPER::fabricar($class);
        foreach my $key (keys %{$args}) {
          $obj->$key($args->{$key});
        }
        $obj = $self->builder->build($obj);
        $Moore::logger->info("Se creo a ", uc($obj->nombre), ": ", $obj->json);
		return $obj;
	}

1;