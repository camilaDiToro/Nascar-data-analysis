declare variable $err external;

(: Recibe como parametro un nodo driver. Si el driver tiene un auto, devuelve el :)
(: el elemento <car> cuyo contenido será el nombre del fabricante :)
(: Si no posee auto, no devuelve nada:)
declare function local:get_car($driver){
    
    if(fn:exists($driver/car/child::node())) then
        <car>{xs:string(($driver/car/manufacturer/@name)[1])}</car>
    else
        ()
};

(: Funcion que devuelve un nodo driver con la información correspondiente:)
(: Insertamos el elemento car solo si el corredor tiene un auto. Esta validación :)
(: es realizada por la funcion get_car:)
(: Recibe como parametro un nodo driver y sus estadisticas:)
declare function local:get_driver($driver, $statistics)as node(){
    <driver>
        <full_name>{xs:string($driver/@full_name)}</full_name>
        <country>{xs:string($driver/@country)}</country>
        <birth_date>{xs:string($driver/@birthday)}</birth_date>
        <birth_place>{xs:string($driver/@birth_place)}</birth_place>
        <rank>{xs:string($statistics/@rank)}</rank>
        {local:get_car($driver)}
        <statistics>
            <season_points>{xs:string($statistics/@points)}</season_points>
            <wins>{xs:string($statistics/@wins)}</wins>
            <poles>{xs:string($statistics/@poles)}</poles>
            <races_not_finished>{xs:string($statistics/@dnf)}</races_not_finished>
            <laps_completed>{xs:string($statistics/@laps_completed)}</laps_completed>
        </statistics>
    </driver>
};


(:Evaluamos si hubo errores.:)

if(xs:integer($err) eq 0) then

(:Si no hubo errores, procedemos a generar el xml como indica la consigna:)

let $standings:=doc("drivers_standings.xml")/series
return
    <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">{"&#10;"}
        <year>{xs:string($standings/season/@year)}</year>
        <serie_type>{xs:string($standings/@name)}</serie_type>
        <drivers>
            {

(:          Ordenamos los drivers alfabeticamente y por cada uno de ellos devolvemos un nodo:)

            for $driver in doc("drivers_list.xml")//driver
            let $statistics:= $standings//driver[./@id = $driver/@id]
            order by $driver/@full_name
            return local:get_driver($driver,$statistics) (:esta funcion devuelve el nodo driver:)
            }
        </drivers>
    </nascar_data>

else

(:Si hubo errores, generamos un xml en el que se indica el error correspondiente:)
(:Recibimos por parametro el id del error que queremos indicar. El id del error en el :)
(:documento errores.xml se corresponde con retoron de las validaciones realizadas previamente:)

<nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">{"&#10;"}
    <error>{doc("errors.xml")//err[@id=$err]/text()}</error>
</nascar_data>


(:java net.sf.saxon.Query -q:extract_nascar_data.xq err=1 > nascar_data.xml:)

