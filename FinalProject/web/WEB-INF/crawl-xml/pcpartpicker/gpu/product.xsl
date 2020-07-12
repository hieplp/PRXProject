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
    
    <xsl:template match="t:gpus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:element name="gpus">
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
            
            <xsl:variable name="chipset">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Chipset')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            
            <xsl:variable name="link" select="concat($host, xh:a[@class='p-name']/@href)"/>
            <xsl:variable name="detailsDoc" select="document($link)//*[contains(@class, 'technical-table')]/xh:div/xh:table/xh:tbody/xh:tr"/>
            
            <xsl:variable name="tdp">
                <xsl:call-template name="getTDP">
                    <xsl:with-param name="details" select="$detailsDoc"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="(number($price) = $price and boolean($chipset)) and (number($tdp) = $tdp)">
                
                <xsl:element name="gpu">
                    
                    <xsl:element name="name">
                        <xsl:value-of select="xh:a[@class='p-name']"/>
                    </xsl:element>
                   
                    <xsl:element name="chipset">
                        <xsl:value-of select="$chipset"/>
                    </xsl:element>
                      
                    <xsl:element name="image">
                        <xsl:value-of select="concat($host, xh:a[@class='p-img']/xh:img/@data-src)"/>
                    </xsl:element>
                    
                    <xsl:element name="price">
                        <xsl:value-of select="$price"/>
                    </xsl:element>
                    
                    <xsl:variable name="memory">
                        <xsl:call-template name="getText">
                            <xsl:with-param name="str">
                                <xsl:call-template name="uppercase">
                                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Bộ nhớ')]"/>
                                </xsl:call-template>
                            </xsl:with-param> 
                            <xsl:with-param name="startChar" select="':'"/>
                            <xsl:with-param name="endChar" select="'-'"/>
                        </xsl:call-template>
                    </xsl:variable> 
                    
                    <xsl:element name="memory">
                        <xsl:element name="capacity">
                            <xsl:value-of select="substring-before($memory, 'GB')"/>
                        </xsl:element>
                        <xsl:element name="type">
                            <xsl:choose>
                                <xsl:when test="contains($memory, '/')">
                                    <xsl:choose>
                                        <!--ex: 8GB/256 bit GDDR6 to GDDR6-->
                                        <xsl:when test="contains($memory, 'GB/')">
                                            <xsl:call-template name="getLastStr">
                                                <xsl:with-param name="str" select="$memory"/>
                                                <xsl:with-param name="delimiter" select="' '"/>
                                            </xsl:call-template>
                                        </xsl:when> 
                                        <!--ex: 8Gb GDDR6/ 256 Bit to GDDR6-->
                                        <xsl:otherwise>
                                            <xsl:call-template name="getTextBetween2Chars">
                                                <xsl:with-param name="str" select="$memory"/>
                                                <xsl:with-param name="startChar" select="'GB'"/>
                                                <xsl:with-param name="endChar" select="'/'"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <!--ex: 8GB GDDR6 ( 256-bit ) to GDDR6-->
                                <xsl:when test="contains($memory, '(')">
                                    <xsl:call-template name="getTextBetween2Chars">
                                        <xsl:with-param name="str" select="$memory"/>
                                        <xsl:with-param name="startChar" select="'GB'"/>
                                        <xsl:with-param name="endChar" select="'('"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <!--ex: 8GB GDDR6 to GDDR6-->
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(substring-after($memory, 'GB'))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                    
                    <xsl:element name="tdp">
                        <xsl:value-of select="$tdp"/>
                    </xsl:element>
                    
                    <xsl:call-template name="getMoreInfo">
                        <xsl:with-param name="details" select="$detailsDoc"/>
                    </xsl:call-template>
                 
                </xsl:element> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="getMoreInfo">
        <xsl:param name="details"/>
        
        <xsl:element name="brand">
            <xsl:call-template name="getTextDetail">
                <xsl:with-param name="info" select="$details[contains(xh:td, 'sản') or contains(xh:td, 'Hãng')]/xh:td[2]"/>
            </xsl:call-template>
        </xsl:element>
                
        <xsl:element name="interface">
            <xsl:call-template name="getTextDetail">
                <xsl:with-param name="info" select="$details[contains(xh:td[2], 'PCI')]/xh:td[2]"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="getTDP">
        <xsl:param name="details"/>
        <xsl:variable name="tdp" select="$details[contains(xh:td, 'nguồn') or contains(xh:td, 'TDP')]/xh:td[2]"/>
        <xsl:choose>
            <xsl:when test="$tdp/xh:p">
                <xsl:call-template name="getOnlyNumber">
                    <xsl:with-param name="str" select="substring-before($tdp/xh:p, 'W')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$tdp/xh:span">
                <xsl:call-template name="getOnlyNumber">
                    <xsl:with-param name="str" select="substring-before($tdp/xh:span, 'W')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="getOnlyNumber">
                    <xsl:with-param name="str" select="substring-before($tdp, 'W')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
