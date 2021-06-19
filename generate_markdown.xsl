<?xml version="1.0" ?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="/">
        <xsl:if test="//error">
            <xsl:value-of select="//error"/>
        </xsl:if>

        <xsl:if test="not(//error)">
            <xsl:call-template name="no_errors"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="no_errors">

        <xsl:value-of select="//year"/>
        <xsl:text> for </xsl:text>
        <xsl:value-of select="//serie_type"/>

        <xsl:for-each select="//drivers/driver">
            <xsl:call-template name="driver">
                <xsl:with-param name="driver" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="driver">
        <xsl:param name="driver"/>

        <xsl:text>&#xa;*** </xsl:text>
        <xsl:text>&#xa;###</xsl:text><xsl:value-of select="$driver/full_name"/>
        <xsl:text>&#xa;1.  Country: </xsl:text><xsl:value-of select="$driver/country"/>
        <xsl:text>&#xa;2.  Birth date: </xsl:text><xsl:value-of select="$driver/birth_date"/>
        <xsl:text>&#xa;3.  Birthplace: </xsl:text><xsl:value-of select="$driver/birth_place"/>

        <xsl:text>&#xa;4.  Car manufacturer: </xsl:text>
            <xsl:if test="$driver/car = ''"><xsl:text> - &#xa;</xsl:text></xsl:if>
            <xsl:if test="not($driver/car = '')">
                <xsl:value-of select="$driver/car"/>
            </xsl:if>

        <xsl:text>&#xa;5.  Rank: </xsl:text>
            <xsl:if test="$driver/rank = ''"><xsl:text> - &#xa;</xsl:text></xsl:if>
            <xsl:if test="not($driver/rank = '')">
                <xsl:value-of select="$driver/rank"/>
                <xsl:call-template name="show_statistics">
                    <xsl:with-param name="stat" select="$driver/statistics"/>
                </xsl:call-template>
            </xsl:if>
    </xsl:template>

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

<!--        java net.sf.saxon.Transform -s:nascar_data.xml -xsl:generate_markdown.xsl -o:nascar_page.md-->
