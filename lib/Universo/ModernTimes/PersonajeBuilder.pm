package Universo::ModernTimes::PersonajeBuilder;
use strict;
use Data::Dumper;
use List::Util qw(shuffle);
use fields qw(_personaje);

our $actual;

	sub new {
		my $self = shift;
		$self = fields::new($self);
		$Moore::logger->info('Se instacion un nuevo ', ref($self));
		return $self;
	}

    sub build {
      	my $self = shift;
        my $personaje = shift;
        $self->personaje($personaje);

        $self->personaje->sexo(int(rand(2)) == 1 ? 'f' : 'm') if !$self->personaje->sexo;

        $self->asignar_nombre;

        $self->personaje->edad(int(rand(25)) + 15);

        $self->asignar_detalles;

        $self->asignar_categoria('attribute', [qw(physical social mental)], [10,8,6]);
        $self->asignar_categoria('ability', [qw(skill knowledge talent)], [13,9,5]);

        $self->asignar_tag_random(10, 'virtue');
        $self->asignar_tag_random(7, 'background');

        return $personaje;
    }

    sub asignar_detalles {
        my $self = shift;
        my $hash = {};
        $hash->{color} = [shuffle(qw(moroch[a|o] rubi[a|o] castañ[a|o] castañ[a|o] peliroj[a|o]))]->[0];
        $self->personaje->pelo_color($hash->{color});
    }

    sub asignar_nombre {
        my $self = shift;
        return $self->personaje->nombre if $self->personaje->nombre;
        my $nombres = [];
        if($self->personaje->sexo eq 'f') {
                $nombres = [qw(Lucia Maria Martina Paula Daniela Sofia Valeria Carla Sara Alba Julia Noa Emma Claudia Carmen Marta Valentina Irene Adriana Ana Laura Elena Alejandra Ines Marina Vera Candela Laia Ariadna Lola Andrea Rocio Angela Vega Nora Jimena Blanca Alicia Clara Olivia Celia Alma Eva Elsa Leyre Natalia Victoria Isabel Cristina Lara Abril Triana Nuria Aroa Carolina Aina Manuela Chloe Mia Mar Gabriela Mara Africa Iria Naia Helena Paola Noelia Nahia Miriam Salma)]
        } else {
                $nombres = [qw(Hugo Daniel Pablo Alejandro Alvaro Adrian David Martin Mario Diego Javier Manuel Lucas Nicolas Marcos Leo Sergio Mateo Izan Alex Iker Marc Jorge Carlos Miguel Antonio Angel Gonzalo Juan Ivan Eric Ruben Samuel Hector Victor Enzo Jose Gabriel Bruno Dario Raul Adam Guillermo Francisco Aaron Jesus Oliver Joel Aitor Pedro Rodrigo Erik Marco Alberto Pau Jaime Asier Luis Rafael Unai Mohamed Dylan Marti Ian Pol Ismael Oscar Andres Alonso Biel Rayan Jan Fernando Thiago Arnau Cristian Gael Ignacio Joan)]
        }
        my $nombre = $nombres->[int(rand(@{$nombres}))];
        $self->personaje->nombre($nombre);
    }

    sub asignar_categoria {
        my $self = shift;
        my $categoria = shift;
        my $tags = shift;
        my $puntos = shift;

        my $estructura = $self->estructura($categoria, $tags, $puntos);

        foreach my $tag (keys %$estructura) {
            $self->asignar_tag_random($estructura->{$tag}->{puntos_asignados}, $tag);
        }
    }

    sub estructura {
        my $self = shift;
        my $categoria = shift;
        my $tags = shift;
        my $puntos = shift;
        my $estructura = {};
        foreach my $tag (@{$tags}) {
            $self->estructura_tag($estructura, $tag, $puntos);
        }

        $self->estructura_validar($estructura,$puntos);

        $self->estructura_puntos_asignados($estructura, $puntos);

        return $estructura;
    }


    sub estructura_puntos_asignados {
        my $self = shift;
        my $estructura = shift;
        my $puntos = shift;
        my $puntos_tmp = [@{$puntos}];
        foreach my $value (sort {$b->{min} <=> $a->{min}} values %$estructura) {
            my $tag = $value->{tag};
            my $c = 0;
            while(1) {
                $c++;
                $puntos_tmp = [shuffle(@{$puntos_tmp})];
                my $puntos_a_asignar = $puntos_tmp->[0];
                last if !$puntos_a_asignar;
                die "Se corto el ciclo por demasiadas iteraciones. " if $c == 15;
                my $boo = 0;
                foreach my $posibles_puntos (@{$estructura->{$tag}->{posibles_puntos}}) {
                  $boo = 1 if $posibles_puntos == $puntos_a_asignar;
                  last if $boo;
                }
                next if !$boo;
                $estructura->{$tag}->{puntos_asignados} = shift(@{$puntos_tmp});
                $Moore::logger->trace("Se asigno ", $estructura->{$tag}->{puntos_asignados}, " para ", $tag, " para el personaje ", $self->personaje->nombre);
                last;
            }
        }
    }

    sub estructura_tag {
        my $self = shift;
        my $estructura = shift;
        my $tag = shift;
        my $valores = shift;
        my $min = 0;
        $estructura->{$tag}->{tag} = $tag;
        $estructura->{$tag}->{atributos} = Universo->actual->atributo($tag);
        foreach my $atributo (@{$estructura->{$tag}->{atributos}}) {
            my $nombre = $atributo->{nombre};
            if($self->personaje->$nombre) {
                $min += $self->personaje->$nombre;
            } else {
                $min += $atributo->{validos}->[0];
            }
        }
        $estructura->{$tag}->{min} = $min;
        $estructura->{$tag}->{posibles_puntos} = [grep {$min < $_} @$valores];
    }


    sub estructura_validar {
        my $self = shift;
        my $estructura = shift;
        my $puntos = shift;
        my $hash = {};
        map {$hash->{$_} = 0} @{$puntos};
        foreach my $tag (keys %$estructura) {
            map {$hash->{$_} = 1} @{$estructura->{$tag}->{posibles_puntos}};
        }
        if(scalar(grep {$hash->{$_} == 1} keys {%$hash}) != scalar @$puntos) {
            my $msg = join('', 'No se puede distribuir [', join(' ', @$puntos), '] para el personaje: ', $self->personaje->json);
            $Moore::logger->error($msg);
            die $msg;
        }
    }

    sub asignar_tag_random {
        my $self = shift;
        my $puntos = shift;
        my $tag = shift;
        my $filtrados = [];
        my $atributos = Universo->actual->atributo($tag);
        $self->filtrados_y_defaults($atributos,$filtrados);
        $self->asignar_puntos_random($atributos,$puntos,$filtrados);    
    }

    sub asignar_puntos_random {
        my $self = shift;
        my $atributos = shift;
        my $puntos = shift;
        my $filtrados = shift;
        while (1) {
            $atributos = [shuffle(@{$atributos})];
            my $atributo = $atributos->[0];
            my $nombre = $atributo->{nombre};
            next if grep {$_ eq $nombre} @{$filtrados};
            my $valor = $self->personaje->$nombre;
            $valor++;
            next if !grep {$_ == $valor} @{$atributo->{validos}};
            $self->personaje->$nombre($valor);
            my $sum = $self->personaje->sum($atributos);
            last if $sum == $puntos;
        }
    }

    sub filtrados_y_defaults {
        my $self = shift;
        my $atributos = shift;
        my $filtrados = shift;
        foreach my $atributo (@{$atributos}) {
            my $nombre = $atributo->{nombre};
            if(defined $self->personaje->$nombre) {
                push @{$filtrados}, $atributo->{nombre};
                $Moore::logger->trace("Se filtra el atributo ", $nombre, " para el personaje ", $self->personaje->nombre, " por que tiene el valor fijado en ",$self->personaje->$nombre);
            }
            if($atributo->{validos}->[0]) {
                $self->personaje->$nombre($atributo->{validos}->[0]) if !$self->personaje->$nombre;
            }
        }

    }

    sub personaje {
        my $self = shift;
        my $personaje = shift;
        $self->{_personaje} = $personaje if defined $personaje;
        return $self->{_personaje};    
    }
1;