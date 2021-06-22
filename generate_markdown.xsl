<?xml version="1.0" ?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <!-- Primero evaluamos si hubo errores en el chequeo de los parametros.
         1) Si hubo errores, el archivo Markdown contendrá el error correspondiente.
         2) Caso contrario, mostramos la información solicitada mediante el template "no_errors".  -->

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="//error">
                <xsl:value-of select="//error"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="no_errors"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Template que se encarga de darle el formato correspondiente a los distintos campos del XML para obtener 
         la salida indicada en la consigna.  -->

    <xsl:template name="no_errors">

        <!-- Mostramos el titulo como un heading de nivel 1, seguido por una linea divisoria. -->

        <xsl:text># Drivers for </xsl:text>
        <xsl:value-of select="//serie_type"/>
        <xsl:text> for </xsl:text>
        <xsl:value-of select="//year"/>
        <xsl:text> season &#xa;*** </xsl:text>

        <!-- Mostramos la información que corresponde a cada uno de los drivers utilizando el template "driver". -->

        <xsl:for-each select="//drivers/driver">
            <xsl:call-template name="driver">
                <xsl:with-param name="driver" select="."/>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>

    <!-- Template que recibe un elemento driver y muestra su informacion.
         Si el driver no posee el tag <car>, se mostrara en car manufacturer un guión "-".
         Si el driver posee un rank, se mostara su ranking en el y sus estadisticas. Caso contrario, se mostrara un
         guion "-" y no apareceran las estadisticas. Las estadisticas las obtenemos mediante el template "show_statistics".
         Para cualquier elemento, si el tag correspondiente está vacio se mostrara un guion "-" en el lugar de su contenido. -->

    <xsl:template name="driver">
        <xsl:param name="driver"/>

        <xsl:text>&#xa;*** </xsl:text>
        <xsl:text>&#xa;### </xsl:text><xsl:value-of select="$driver/full_name"/>

        <xsl:text>&#xa;1.  Country: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$driver/country"/>
        </xsl:call-template>

        <xsl:text>&#xa;2.  Birth date: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$driver/birth_date"/>
        </xsl:call-template>

        <xsl:text>&#xa;3.  Birthplace: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$driver/birth_place"/>
        </xsl:call-template>

        <xsl:text>&#xa;4.  Car manufacturer: </xsl:text>
        <xsl:choose>
            <xsl:when test="$driver/car">
                <xsl:value-of select="$driver/car"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>-</xsl:text>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:text>&#xa;5.  Rank: </xsl:text>
        <xsl:choose>
            <xsl:when test="$driver/rank = ''">
                <xsl:text> - &#xa;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$driver/rank"/>
                <xsl:call-template name="show_statistics">
                    <xsl:with-param name="stat" select="$driver/statistics"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- Template que muestra las estadisticas de un driver, este template solo será llamado en caso de que
         el driver posea estadisticas. -->

    <xsl:template name="show_statistics">
        <xsl:param name="stat"/>
        <xsl:text>&#xa;##### Statistics </xsl:text>

        <xsl:text>&#xa;- Season points: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$stat/season_points"/>
        </xsl:call-template>

        <xsl:text>&#xa;- Wins: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$stat/wins"/>
        </xsl:call-template>

        <xsl:text>&#xa;- Poles:  </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$stat/poles"/>
        </xsl:call-template>

        <xsl:text>&#xa;- Races not finished: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$stat/races_not_finished"/>
        </xsl:call-template>

        <xsl:text>&#xa;- Laps completed: </xsl:text>
        <xsl:call-template name="value-or-empty">
            <xsl:with-param name="value" select="$stat/laps_completed"/>
        </xsl:call-template>

        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Función que recibe un nodo. -->
    <!-- Si el nodo está vacio pone un "-", caso contrario pone el contenido del nodo recibido por parametro. -->

    <xsl:template name="value-or-empty">
        <xsl:param name="value"/>
        <xsl:choose>
            <xsl:when test="$value = ''">
                <xsl:text> - </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:transform>

