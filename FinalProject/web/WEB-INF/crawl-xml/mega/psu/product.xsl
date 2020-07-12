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
                <xsl:with-param name="currentLink" select="@link"/>
                <xsl:with-param name="host" select="@host"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="itemDetailList">
        <xsl:param name="items"/>
        <xsl:param name="host"/>
        <xsl:for-each select="$items">
            <xsl:variable name="summary" select="xh:div[@class='p-summary']/xh:ul/xh:li"/>
            
            <xsl:variable name="brand">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Hãng sản xuất')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="tdp">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Công suất')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'W'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="efficiency">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Hiệu năng')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'%'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            
            <xsl:if test="(number($price) = $price and boolean($tdp)) and boolean($efficiency)">
                
                <xsl:element name="psu">
                    
                    <xsl:element name="name">
                        <xsl:value-of select="xh:a[@class='p-name']"/>
                    </xsl:element>
                   
                    <xsl:element name="brand">
                        <xsl:value-of select="$brand"/>
                    </xsl:element>
                      
                    <xsl:element name="image">
                        <xsl:value-of select="concat($host, xh:a[@class='p-img']/xh:img/@data-src)"/>
                    </xsl:element>
                    
                    <xsl:element name="price">
                        <xsl:value-of select="$price"/>
                    </xsl:element>
                    
                    <xsl:element name="tdp">
                        <xsl:value-of select="$tdp"/>
                    </xsl:element>
                    
                    <xsl:element name="efficiency">
                        <xsl:call-template name="getOnlyNumber">
                            <xsl:with-param name="str" select="$efficiency"/>
                        </xsl:call-template>
                    </xsl:element>
                 
                </xsl:element> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
