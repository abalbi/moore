package ModernTimes;
use base 'Universo';
use ModernTimes::PersonajeBuilder;
use ModernTimes::EventoBuilder;
use ModernTimes::Atributo;
use ModernTimes::Evento;
use ModernTimes::Roll;
use Data::Dumper;
use JSON;
use List::Util qw(shuffle);
use List::MoreUtils qw(zip);


	sub hacer_atributos {
		my $self = shift;
		push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'sexo' });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'nombre'   });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'edad'   });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'pelo_color'   });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'pelo_largo'   });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'pelo_forma'   });
        push @{$self->{_atributos}}, ModernTimes::Atributo->hacer({ nombre => 'altura'   });
        push @{$self->{_atributos}}, map { 
            ModernTimes::Atributo->hacer({
                nombre => $_,
                validos => [1..5],
                tags => [$_, qw(virtue)],
                descripciones => 
                    $_ eq 'conviction' ? {1 => 'estable', 2 => 'determinad[a|o]', 3 => 'impulsiv[a|o]', 4 => 'brutal', 5 => 'completamente segur[a|o]'} :
                    $_ eq 'instinct' ? {1 => 'intuitiv[a|o]', 2 => 'feral', 3 => 'bestial', 4 => 'visceral', 5 => 'primari[a|o]'} :
                    {1 => 'cobarde', 2 => 'precavid[a|o]', 3 => 'brav[a|o]', 4 => 'resuelt[a|o]', 5 => 'heroic[a|o]'}

            }) 
        } qw(conviction instinct courage);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [1..5], tags => [qw(attribute, physical)]}) } qw(strengh dexterity stamina);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [1..5], tags => [qw(attribute, social)]}) } qw(manipulation appearance charisma);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [1..5], tags => [qw(attribute, mental)]}) } qw(intelligence perception wits);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [0..5], tags => [qw(ability, talent)]}) } qw(athletics brawl dodge empathy expression intimidation leadership streetwise subterfuge);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [0..5], tags => [qw(ability, skill)]}) } qw(animal_ken crafts drive etiquette firearms melee performance security stealth survival);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [0..5], tags => [qw(ability, knowledge)]}) } qw(academics bureaucracy computer finance investigation law linguistics medicine occult politics research science);
        push @{$self->{_atributos}}, map { ModernTimes::Atributo->hacer({nombre => $_, validos => [0..5], tags => [qw(background)]}) } qw(allies contacts fame influence mentor resources status);
        $Moore::logger->trace("Se cargaron los atributo: ", join(',',map {$_->nombre} @{$self->{_atributos}}));
        $self->personaje_builder(ModernTimes::PersonajeBuilder->new);
        push @{$self->{_eventos}}, ModernTimes::Evento->hacer({
                nombre => 'CHANTAJE',
                tags => ['CHANTAJE'],
                sujeto => {conviction => [3..5], courage => [3..5]},
                objeto => {courage => [1..2]},
                texto => "%s %s a %s",
                verbo => 'chantajea'
        });
        $self->evento_builder(ModernTimes::EventoBuilder->new);
	}

    sub descripcion {
        my $self = shift;
        my $obj = shift;
        my $str = '';
        if(ref($obj) eq 'Personaje') {
                $str = $self->descripcion_personaje($obj);
            } elsif (ref($obj) eq 'Evento') {
                $str = $self->descripcion_evento($obj);
            }
        return $str;
    }

    sub descripcion_evento {
        my $self = shift;
        my $evento = shift;
        my $str = '';
        $str .= sprintf $evento->texto, $evento->sujeto->nombre, $evento->verbo, $evento->objeto->nombre;
        return $str;        
    }

    sub descripcion_personaje {
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
            Moore->t($personaje, Universo::actual->atributo('conviction')->descripciones->{$personaje->conviction}),
            $personaje->conviction
        ;
        $str .= sprintf ", %s(instinct:%s)", 
            Moore->t($personaje, Universo::actual->atributo('instinct')->descripciones->{$personaje->instinct}),
            $personaje->instinct
        ;
        $str .= sprintf " y %s(courage:%s)", 
            Moore->t($personaje, Universo::actual->atributo('courage')->descripciones->{$personaje->courage}),
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
        if($class eq 'Personaje') {
            $obj = $self->personaje_builder->build($obj);
            $Moore::logger->info("Se creo a ", uc($obj->nombre), ": ", $obj->json);
        } elsif ($class eq 'Evento') {
            $obj = $self->evento_builder->build($obj,$args);
            $Moore::logger->info("Se creo a ", uc($obj->nombre), ": ", $obj->json) if $obj;
        }
		return $obj;
	}

    sub roll {
        my $roll = shift;
        my $roll = ModernTimes::Roll->new($roll);
        $roll->roll;
        return $roll;
    }


1;