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
    
    <xsl:template match="t:cpus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <xsl:element name="cpus">
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
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            <xsl:variable name="socket" select="normalize-space(substring-after($summary[contains(xh:span, 'Socket')], ':'))"/>
            <xsl:if test="(number($price) = $price) and boolean($socket)">
                
                <xsl:element name="cpu">
                    <xsl:element name="name">
                        <!--remove unnessary inforamtion after '/' and '('--> 
                        <xsl:variable name="itemName" select="translate(xh:a[@class='p-name'], '(', '/')"/>
                        <xsl:choose>
                            <xsl:when test="contains($itemName, '/')">
                                <xsl:value-of select="substring-before($itemName, '/')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$itemName"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    
                    <xsl:element name="image">
                        <xsl:value-of select="concat($host, xh:a[@class='p-img']/xh:img/@data-src)"/>
                    </xsl:element>
                    
                    <xsl:element name="price">
                        <xsl:value-of select="$price"/>
                    </xsl:element>
                    
                    <xsl:element name="socket">
                        <xsl:value-of select="$socket"/>
                    </xsl:element>
                    
                    <xsl:call-template name="getMoreInfo">
                        <xsl:with-param name="link" select="concat($host, xh:a[@class='p-name']/@href)"/>
                    </xsl:call-template>
                    
                    <xsl:variable name="secondSummary" select="normalize-space(substring-after($summary[contains(xh:span, 'Cache')], ':'))"/>
                    <!--Get speed information-->
                    <xsl:element name="speed">
                        <xsl:choose>
                            <xsl:when test="contains($secondSummary, '/')">
                                <!--get data before '/' then convert, ex: 'Up to 3.5Ghz/ 5Mb' to '3.5Ghz'-->
                                <xsl:value-of select="normalize-space(translate(substring-before($secondSummary, '/'), 'Up to', ''))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$secondSummary"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
<!--                    Get cache information
                    <xsl:element name="cache">
                        get data after '/' then convert, ex: 'Up to 3.5Ghz/ 5Mb' to '5Mb'
                        <xsl:value-of select="normalize-space(substring-after($secondSummary, '/'))"/>
                    </xsl:element>-->
                    
                    <!--thirdSummary includes core and cache-->
                    <xsl:variable name="thirdSummary" select="normalize-space(substring-after($summary[contains(xh:span, 'Số nhân')], ':'))"/>
                    <xsl:element name="core">
                        <!--get data after '/' then convert, ex: '6 Core/ 12 Threads' to '6'-->
                        <xsl:value-of select="normalize-space(translate(substring-before($thirdSummary, '/'), 'Core', ''))"/>
                    </xsl:element>
                    <xsl:element name="thread">
                        <!--get data after '/' then convert, ex: '6 Core/ 12 Threads' to '12'-->
                        <xsl:value-of select="normalize-space(translate(substring-after($thirdSummary, '/'), 'Threads', ''))"/>
                    </xsl:element>
                </xsl:element> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="getMoreInfo">
        <xsl:param name="link"/>
        <xsl:variable name="details" select="document($link)//*[contains(@class, 'technical-table')]/xh:div/xh:table/xh:tbody/xh:tr"/>
        
        <xsl:variable name="tdp" select="$details[contains(xh:td, 'thụ') or contains(xh:td, 'TDP')]/xh:td[2]"/>
        <xsl:element name="tdp">
            <xsl:choose>
                <xsl:when test="$tdp/xh:p">
                    <xsl:call-template name="getOnlyNumber">
                        <xsl:with-param name="str" select="$tdp/xh:p"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$tdp/xh:span">
                    <xsl:call-template name="getOnlyNumber">
                        <xsl:with-param name="str" select="$tdp/xh:span"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getOnlyNumber">
                        <xsl:with-param name="str" select="$tdp"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        
        <xsl:variable name="brand" select="$details[contains(xh:td, 'sản') or contains(xh:td, 'Thương hiệu')]/xh:td[2]"/>
        <xsl:element name="brand">
            <xsl:choose>
                <xsl:when test="$brand/xh:p">
                    <xsl:value-of select="$brand/xh:p"/>
                </xsl:when>
                <xsl:when test="$brand/xh:span">
                    <xsl:value-of select="$brand/xh:span"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$brand"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
      
        
    </xsl:template>

</xsl:stylesheet>
