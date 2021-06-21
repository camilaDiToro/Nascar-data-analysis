#!/bin/bash

. ./full_validations.sh

check_parameters $# $*
valid_parameters=$?

if [ $valid_parameters -eq 0 ]
    then

      # Pasamos a minuscula lo que tenemos en el parametro $2

      category=${2,,}
      
      curl -X GET "http://api.sportradar.us/nascar-ot3/${category}/${1}/drivers/list.xml?api_key=${SPORTRADAR_API}" -o drivers_list.xml
      curl -X GET "http://api.sportradar.us/nascar-ot3/${category}/${1}/standings/drivers.xml?api_key=${SPORTRADAR_API}" -o drivers_standings.xml
      
      #Borramos el namespace

      sed -i 's/ xmlns="[^"]*"//' drivers_list.xml && sed -i 's/ xmlns="[^"]*"//' drivers_standings.xml
fi

java net.sf.saxon.Query -q:extract_nascar_data.xq err=$valid_parameters > nascar_data.xml

java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_markdown.xsl -o:nascar_page.md
