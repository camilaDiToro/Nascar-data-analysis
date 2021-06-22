#!/bin/bash

. ./full_validations.sh

# Llamamos a la funcion principal del archivo full_validations.sh.

check_parameters $# $*
valid_parameters=$?

# Si la funcion check_parameters retorna cero, significa que los parametros son correctos y es seguro llamar a la API para obtener los XML que nos serviran de base.

if [ $valid_parameters -eq 0 ]
    then

      # Pasamos a minuscula lo que tenemos en el parametro $2 para llamar correctamente a la API.

      category=${2,,}

      # Hacemos el llamado a la API con los parametros recibidos por entrada estandar.

      curl -X GET "http://api.sportradar.us/nascar-ot3/${category}/${1}/drivers/list.xml?api_key=${SPORTRADAR_API}" -o drivers_list.xml
      curl -X GET "http://api.sportradar.us/nascar-ot3/${category}/${1}/standings/drivers.xml?api_key=${SPORTRADAR_API}" -o drivers_standings.xml
      
      # Borramos el namespace de ambos XML's utilizando sed a traves de una expresion regular.

      sed -i 's/ xmlns="[^"]*"//' drivers_list.xml && sed -i 's/ xmlns="[^"]*"//' drivers_standings.xml
fi


# Ejecutamos la consulta xQuery para obtener nascar_data.xml.
# Si valid_parameters tuviera un valor distinto de cero, obtendremos un XML con la leyenda del error producido.

java net.sf.saxon.Query -q:extract_nascar_data.xq err=$valid_parameters > nascar_data.xml

# Ejecutamos la transformacion XSLT de nascar_date.xml para obtener nascar_page.md.

java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_markdown.xsl -o:nascar_page.md
