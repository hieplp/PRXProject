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
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    <xsl:import  href="../../utils.xsl"/>
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <xsl:template match="t:psus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:element name="psus">
            <xsl:call-template name="while">
                <xsl:with-param name="currentPage" select="'1'"/>
                <xsl:with-param name="link" select="@link"/>
                <xsl:with-param name="host" select="@host"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
<!--    <xsl:template name="itemList">
        <xsl:param name="host"/>
        <xsl:param name="items"/>
        <xsl:for-each select="$items">
            <xsl:variable name="price" select="xh:td[contains(@class, 'td__price')]/text()"/>
            <xsl:if test="string-length($price) > 0">
                <xsl:element name="psu">
                    <xsl:element name="name">
                        <xsl:value-of select="xh:td[@class='td__name']/xh:a/xh:div[@class='td__nameWrapper']/xh:p"/>
                    </xsl:element>
                    <xsl:element name="image">
                        <xsl:value-of select="xh:td[@class='td__name']/xh:a/xh:div[@class='td__imageWrapper']/xh:div/xh:img/@src"/>
                    </xsl:element>
                    <xsl:element name="efficiency">
                        <xsl:call-template name="getOnlyNumber">
                            <xsl:with-param name="str" select="xh:td[contains(@class, 'td__spec--2')]/text()"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="wattage">
                        <xsl:call-template name="getOnlyNumber">
                            <xsl:with-param name="str" select="xh:td[contains(@class, 'td__spec--3')]/text()"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="price">
                        <xsl:value-of select="translate($price, '$', '')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>-->
    
</xsl:stylesheet>
