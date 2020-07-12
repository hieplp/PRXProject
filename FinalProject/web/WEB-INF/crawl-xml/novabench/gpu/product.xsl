<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : product.xsl
    Created on : June 25, 2020, 9:52 AM
    Author     : hiepp
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xh="http://www.w3.org/1999/xhtml"
                xmlns:t="prx/xml"
                xmlns="prx/xml">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="t:gpus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:variable name="doc" select="document(@configPath)"/>
        <xsl:element name="gpus">
            <xsl:for-each select="$listDoc//*[@id='filterTable']/xh:tbody/xh:tr">
                <xsl:element name="gpu">
                    <xsl:variable name="gpu" select="xh:td"/>
                    <xsl:element name="name">
                        <xsl:value-of select="$gpu/xh:a"/>
                    </xsl:element>
                    <xsl:element name="score">
                        <xsl:value-of select="$gpu/xh:strong"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
