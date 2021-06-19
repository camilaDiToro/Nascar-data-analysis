#!/bin/bash

# Funcion que chequea si el parametro $1 matchea con la expresion regular recibida en $2.
# Retorna 0 si matchea, 1 sino.
declare -r MAX_PARAMETERS=2

function pattern() {
	if echo "$1" | egrep -i "$2" &> /dev/null
        then
	        return 0
    fi
    return 1
}

# Funcion que chequea si el parametro $1 es un valor numerico.
# Retorna 0 si es un numero, 1 sino.

function is_number(){
	pattern $1 '^[0-9]+$'
	return $?
}

# Funcion que chequea si el parametro $1 es un año valido en el rango [2013 - 2021].
# Retorna 0 si es un año valido, 2 si el parametro no es numero o no esta en el intervalo de años correspondiente.

function check_year(){

    is_number $1
    valid_number=$?

    if [ $valid_number -eq 1 ]
        then
            return 2
    fi

	if [ $1 -lt 2013 ] || [ $1 -gt 2021 ]
        then
    		return 2
	fi
            return 0
}

# Funcion que chequea si el parametro correspondiente $1 es un tipo de competicion valido.
# La funcion no es case sensitive. POr ende, los strings 'mC', 'mC' o 'MC' matchearan con la expresion regular.
# Retorna 0 si es un tipo de competicion valido, 3 sino.

function check_category() {

    pattern "$1" 'mc|sc|xf|cw|go|enas'
	function_return=$?

    if [ $function_return -eq 1 ]
        then
                return 3
    fi
                return 0
}

# Funcion que devuelve la suma de los distintos errores que puede haber durante el chequeo de los parametros
# recibidos por entrada estandar: año ($1) y type ($2)
# Retorna 0 si no hubo errores en los chequeos.
# Retorna 1 si la cantidad de parametros recibidos por entrada estandar son invalidos. Solo recibimos dos, el year y el type.
# Retorna 2 si el tipo de competicion es valido y el año no es un numero o no esta en el intervalo [2013 - 2021].
# Retrona 3 si el tipo de competicion es invalido y el año es valido.
# Retorna 5 si el tipo de competicion es invalido y el año no es numero o el año no corresponde al intervalo [2013 - 2021].

function check_parameters() {

    if [ $1 -ne $MAX_PARAMETERS ]
        then
            return 1
    fi

    check_year $2
    year_check_value=$?

    check_category $3
    type_check_value=$?

    toReturn="$((year_check_value+type_check_value))"

    return $toReturn
}
