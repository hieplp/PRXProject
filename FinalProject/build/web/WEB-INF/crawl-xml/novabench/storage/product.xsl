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
    <xsl:template match="t:storages">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:element name="storages">
            <xsl:for-each select="$listDoc//*[@id='filterTable']/xh:tbody/xh:tr">
                <xsl:element name="storage">
                    <xsl:variable name="sto" select="xh:td"/>
                    <xsl:element name="name">
                        <xsl:value-of select="$sto/xh:a"/>
                    </xsl:element>
                    <xsl:element name="type">
                        <xsl:value-of select="$sto/xh:small"/>
                    </xsl:element>
                    <xsl:element name="score">
                        <xsl:value-of select="$sto/xh:strong"/>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
