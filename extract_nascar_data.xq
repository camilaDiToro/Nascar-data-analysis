
(: Recibimos en la variable $err el valor de retorno de la funcion check_parameters, del archivo full_validations.sh :)
(: El valor de la variable será 0 si no hubo errores y será distinto de 0 si hubo algún error en los parametros recibidos:)

declare variable $err external;


(:-------------------------Funciones auxiliares-----------------------------:)

(: Funcion que recibe como parametro un nodo driver.
   Retorna el elemento <car> cuyo contenido será el nombre del fabricante en caso de que el driver tenga un auto.
   Si el driver no tiene auto, no devuelve nada:)

declare function local:get_car($driver){
    if(fn:exists($driver/car/child::node())) then
        <car>{xs:string(($driver/car/manufacturer/@name)[1])}</car>
    else
        ()
};


(: Funcion que recibe como parametro un nodo driver y sus estadisticas.
   Retorna un nodo driver con la información correspondiente. :)

(: Algunos comentarios sobre casos particulares:
   1) Insertamos el tag <car> solo si el corredor tiene un auto. Es decir, en caso de que el corredor no tenga auto,
   el tag <car> no aparecerá. Para eso utilizaremos la función get_car.
   2) Para que nascar_data.xml valide contra nascar_data.xsd, el tag <rank> y <statistics> deben aparecer. Aparecerán
   vacíos en caso de que el corredor no tenga un ranking ni estadisticas asignadas. :)

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




(:-------------------------Acá comenzamos a procesar el xml-----------------------------:)

(: Evaluamos si hubo errores. :)

if(xs:integer($err) eq 0) then

(: Si no hubo errores, procedemos a generar nascar_data.xml como indica la consigna. :)

let $standings:=doc("drivers_standings.xml")/series
return
    <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">
        <year>{xs:string($standings/season/@year)}</year>
        <serie_type>{xs:string($standings/@name)}</serie_type>
        <drivers>
            {

                (: Ordenamos los drivers alfabeticamente. Luego, llamamos al a fución get_driver que retornará
                   el nodo driver con la información correspondiente. :)

                for $driver in doc("drivers_list.xml")//driver
                let $statistics:= $standings//driver[./@id = $driver/@id]
                order by $driver/@full_name
                return local:get_driver($driver,$statistics)
            }
        </drivers>
    </nascar_data>

else

(: Si hubo errores, generamos nascar_data.xml indicando el error que se produjo.
   Para eso, recibimos por parametro en la variable $err un numero que se corresponde con el atributo
   id del error que queremos indicar en el archivo errors.xml. :)

<nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">
    <error>{doc("errors.xml")//err[@id=$err]/text()}</error>
</nascar_data>




