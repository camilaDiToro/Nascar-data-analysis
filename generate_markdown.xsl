<?xml version="1.0" ?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <!-- Evaluamos si hubo errores
         Si hubo errores, el archivo Markdown contendrá el error correspondiente.
         Caso contrario, mostramos la información solicitada mediante el template "no_errors".  -->

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



    <xsl:template name="no_errors">

        <!-- Mostramos el titulo como un heading de nivel 1, seguido por una linea divisoria -->

        <xsl:text># Drivers for </xsl:text>
        <xsl:value-of select="//serie_type"/>
        <xsl:text> for </xsl:text>
        <xsl:value-of select="//year"/>
        <xsl:text> season &#xa;*** </xsl:text>

        <!-- Mostramos la información que corresponde a cada uno de los drivers utilizando el template "driver" -->

        <xsl:for-each select="//drivers/driver">
            <xsl:call-template name="driver">
                <xsl:with-param name="driver" select="."/>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>

    <!-- Template que recibe un elemento driver y muestra su informacion
         Si el driver no posee el tag <car>, se mostrara en car manufacturer un guión "-"
         Si el driver posee un rank, se mostara su ranking en el y sus estadisticas. Caso contrario, se mostrara un
         guion y no apareceran las estadisticas. Las estadisticas las obtenemos mediante el template "show_statistics". -->

    <xsl:template name="driver">
        <xsl:param name="driver"/>

        <xsl:text>&#xa;*** </xsl:text>
        <xsl:text>&#xa;### </xsl:text><xsl:value-of select="$driver/full_name"/>
        <xsl:text>&#xa;1.  Country: </xsl:text><xsl:value-of select="$driver/country"/>
        <xsl:text>&#xa;2.  Birth date: </xsl:text><xsl:value-of select="$driver/birth_date"/>
        <xsl:text>&#xa;3.  Birthplace: </xsl:text><xsl:value-of select="$driver/birth_place"/>

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
        <xsl:text>&#xa;- Season points: </xsl:text><xsl:value-of select="$stat/season_points"/>
        <xsl:text>&#xa;- Wins: </xsl:text><xsl:value-of select="$stat/wins"/>
        <xsl:text>&#xa;- Poles:  </xsl:text><xsl:value-of select="$stat/poles"/>
        <xsl:text>&#xa;- Races not finished: </xsl:text><xsl:value-of select="$stat/races_not_finished"/>
        <xsl:text>&#xa;- Laps completed: </xsl:text><xsl:value-of select="$stat/laps_completed"/>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

</xsl:transform>

