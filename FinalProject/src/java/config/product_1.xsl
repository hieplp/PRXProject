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
    <xsl:template match="t:brands">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:variable name="host" select="@host"/>
        <xsl:element name="brands">
            <xsl:call-template name="phoneDetail">
                <xsl:with-param name="link" select="@link"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="phoneList">
        <xsl:param name="link"/>
        <xsl:variable name="phoneListDoc" select="document($link)"/>
        <xsl:for-each select="$phoneListDoc//*[@class='item smartphone']">
            <xsl:element name="phone">
                <xsl:attribute name="name">
                    <xsl:value-of select="xh:a/xh:div/xh:div[@class='title']"/>
                </xsl:attribute>
                <xsl:attribute name="imageLink">
                    <xsl:value-of select="xh:a/xh:img/@data-src"/>
                </xsl:attribute>
                <xsl:variable name="phoneDetailLink" select="xh:a/@href"/>
                <xsl:call-template name="phoneDetail">
                    <xsl:with-param name="link" select="$phoneDetailLink"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="phoneDetail">
        <xsl:param name="link"/>
        <xsl:variable name="phoneDetailDoc" select="document($link)"/>
        <xsl:element name="sceen">
            <xsl:variable name="screen" select="$phoneDetailDoc//*[contains(@class,'item-screen')]"/>
            <xsl:attribute name="diagonal">
                <xsl:value-of select="$screen//xh:span[2]"/>
            </xsl:attribute>
            <xsl:attribute name="resolution">
                <xsl:value-of select="$screen//xh:span[3]"/>
            </xsl:attribute>
            <xsl:attribute name="ratio">
                <xsl:value-of select="$screen//xh:span[5]"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:variable name="hardware" select="$phoneDetailDoc//*[contains(@class,'item-soc')]"/>
        <xsl:variable name="antutu" select="$phoneDetailDoc//*[contains(@class,'item-antutu')]"/>
        <xsl:element name="proccesor">
            <xsl:value-of select="$hardware//xh:span[2]"/>
            <xsl:attribute name="antutuScrore">
                <xsl:value-of select="$antutu//*[contains(@class,'main')]"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="ram">
            <xsl:value-of select="$hardware//xh:span[4]"/>
        </xsl:element>
        <xsl:element name="rom">
            <xsl:value-of select="$hardware//xh:span[5]"/>
        </xsl:element>
        <xsl:variable name="battery" select="$phoneDetailDoc//*[contains(@class,'item-battery')]"/>
        <xsl:element name="battery">
            <xsl:value-of select="$battery//*[contains(@class,'main')]"/>
        </xsl:element>
        <xsl:variable name="camera" select="$phoneDetailDoc//*[contains(@class,'item-camera')]"/>
        <xsl:element name="camera">
            <xsl:element name="frontCamera">
                <xsl:attribute name="resolution">
                    <!--Get content before . -->
                    <xsl:value-of select="substring-before($camera//*[contains(@class, 'group-1')]/xh:span[2],'·')"/>
                </xsl:attribute>
                <xsl:attribute name="aperture">
                    <!--Get content after . -->
                    <xsl:value-of select="substring-after($camera//*[contains(@class, 'group-1')]/xh:span[2],'·')"/>
                </xsl:attribute>
            </xsl:element>
            <xsl:element name="selfCamera">
                <xsl:attribute name="resolution">
                    <!--Get content before . -->
                    <xsl:value-of select="substring-before($camera//*[contains(@class, 'group-3')]/xh:span/text(),'·')"/>
                </xsl:attribute>
                <xsl:attribute name="aperture">
                    <!--Get content after . -->
                    <xsl:value-of select="substring-after($camera//*[contains(@class, 'group-3')]/xh:span/text(),'·')"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    

</xsl:stylesheet>