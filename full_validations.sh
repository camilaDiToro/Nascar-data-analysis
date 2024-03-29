#!/bin/bash

# Definimos una constante MAX_PARAMETERS con la cantidad maxima de parametros que podemos recibir por entrada estandar.

declare -r MAX_PARAMETERS=2

# Funcion que chequea si el parametro $1 matchea con la expresion regular recibida en $2.
# Retorna 0 si matchea, 1 sino.

function pattern() {
	if echo "$1" | egrep -i "$2" &> /dev/null
        then
	        return 0
    fi
    return 1
}

# Funcion que chequea si el parametro $1 es un valor numerico en base 10.
# Retorna 0 si es un numero en base 10 , 1 sino.

function is_number(){
	pattern $1 '^(0|[1-9][0-9]+)$'
	return $?
}

# Funcion que chequea si el parametro $1 es un año valido en el rango natural [2013 - 2021].
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

# Funcion que chequea si el parametro $1 es un tipo de competicion valido.
# Retorna 0 si es un tipo de competicion valido, 3 sino.
# Nota: La funcion no es case sensitive. Por ende, los strings 'mC', 'Mc' o 'MC' matchearan con la expresion regular.

function check_category() {

    pattern "$1" 'mc|sc|xf|cw|go'
	function_return=$?

    if [ $function_return -eq 1 ]
        then
                return 3
    fi
                return 0
}

# Funcion que devuelve un valor para cada uno de los distintos errores que puede haber durante el chequeo de los parametros year y type
# recibidos por entrada estandar.
# Retorna 0 si no hubo errores en los chequeos.
# Retorna 1 si la cantidad de parametros recibidos por entrada estandar es invalida. 
# Retorna 2 si el tipo de competicion es valido y el año no es un numero o no esta en el intervalo [2013 - 2021].
# Retrona 3 si el tipo de competicion es invalido y el año es valido.
# Retorna 4 si se ingresa la categoría enas y un año distinto de 2020.
# Retorna 5 si el tipo de competicion es invalido y el año no es numero o el año no corresponde al intervalo [2013 - 2021].

function check_parameters() {

    if [ $1 -ne $MAX_PARAMETERS ]
        then
            return 1
    fi

    # Chequeamos primero el caso especial de la categoría "enas" que solo es valida para el año 2020 segun SportsRadar.
    # De no haberse ingresado "enas" como type, se prodece a llamar a las funciones check_year y check_category.

    if [ "$3" = "enas" ] 
        then
            if [ $2 -ne 2020 ]
                then 
                    return 4
            else 
                return 0
            fi
    else
            check_year $2
            year_check_value=$?

            check_category $3
            type_check_value=$?
    fi

    # Hacemos la suma de las variables que contienen el valor de retorno de las funciones check_year y check_category.

    toReturn="$((year_check_value+type_check_value))"
   
    return $toReturn
}
