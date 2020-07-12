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
                xmlns:t="prx/novabench/cpu"
                xmlns="prx/xml">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <!--<xsl:import  href="../../utils.xsl"/>-->
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="t:cpus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:element name="cpus">
            <xsl:for-each select="$listDoc//*[@id='filterTable']/xh:tbody/xh:tr">
                <xsl:element name="cpu">
                    <xsl:variable name="cpu" select="xh:td"/>
                    <xsl:element name="name">
                        <xsl:value-of select="translate($cpu/xh:a, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                    </xsl:element>
                    <xsl:element name="score">
                        <xsl:value-of select="$cpu/xh:strong"/>
                    </xsl:element>
                </xsl:element>
               
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
