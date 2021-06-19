declare variable $err external;

declare function local:get_car($driver){
    if(fn:exists($driver/car/child::node())) then
        <car>{xs:string(($driver/car/manufacturer/@name)[1])}</car>
    else
        ()
};

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

if(xs:integer($err) eq 0) then
let $standings:=doc("drivers_standings.xml")/series
return
    <nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">{"&#10;"}
        <year>{xs:string($standings/season/@year)}</year>
        <serie_type>{xs:string($standings/@name)}</serie_type>
        <drivers>
            {
            for $driver in doc("drivers_list.xml")//driver
            let $statistics:= $standings//driver[./@id = $driver/@id]
            order by $driver/@full_name
            return local:get_driver($driver,$statistics)
            }
        </drivers>
    </nascar_data>

else
<nascar_data xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="nascar_data.xsd">{"&#10;"}
    <error>{doc("errors.xml")//err[@id=$err]/text()}</error>
</nascar_data>


(:java net.sf.saxon.Query -q:extract_nascar_data.xq err=1 > nascar_data.xml:)

