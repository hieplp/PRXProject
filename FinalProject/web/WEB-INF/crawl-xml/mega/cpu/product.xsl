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
                xmlns:t="prx/mega/cpu"
                xmlns:n="prx/novabench/cpu"
                xmlns="prx/mega/cpu">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:import  href="../../utils.xsl"/>
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="t:cpus">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <!--        <xsl:variable name="link" select="@link"/>-->
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
            <!--Get price and remove . --> 
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            
            <xsl:if test="(number($price) = $price)">
                <xsl:variable name="itemLink" select="xh:a[@class='p-name']/@href"/>
                <xsl:variable name="details" select="document(concat($host, $itemLink))//*[contains(@class, 'technical-table')]/xh:div/xh:table/xh:tbody/xh:tr"/>
                
                <xsl:variable name="itemName">
                    <xsl:call-template name="getText">
                        <xsl:with-param name="str">
                            <xsl:call-template name="uppercase">
                                <xsl:with-param name="str" select="translate(xh:a[@class='p-name'], '(', '/')"/>
                            </xsl:call-template>
                        </xsl:with-param> 
                        <xsl:with-param name="startChar" select="'CPU'"/>
                        <xsl:with-param name="endChar" select="'/'"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="tdp">
                    <xsl:call-template name="getOnlyNumber">
                        <xsl:with-param name="str">
                            <xsl:call-template name="getTDP">
                                <xsl:with-param name="details" select="$details"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="brand">
                    <xsl:call-template name="getBrand">
                        <xsl:with-param name="details" select="$details"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="socket">
                    <xsl:call-template name="getText">
                        <xsl:with-param name="str" select="xh:div[@class='p-summary']/xh:ul/xh:li[contains(xh:span, 'Socket')]/xh:span"/>
                        <xsl:with-param name="startChar" select="':'"/>
                        <xsl:with-param name="endChar" select="'-'"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:variable name="score">
                    <xsl:variable name="tItemName">
                        <xsl:choose>
                            <xsl:when test="contains($itemName, $brand)">
                                <xsl:value-of select="substring-after($itemName, $brand)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$itemName"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="getScore">
                        <xsl:with-param name="itemName">
                            <xsl:choose>
                                <xsl:when test="contains($itemName, 'BOX')">
                                    <xsl:value-of select="translate(normalize-space(substring-before(translate($tItemName, '-', ' '),'BOX')), ' ', '-')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="translate(normalize-space(substring-after(translate($tItemName, '-', ' '), ' ')), ' ', '-')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param> 
                    </xsl:call-template>
                </xsl:variable>
                
                
                
                <xsl:if test="(string-length($itemName) > 0) and (string-length($tdp) > 0) and (string-length($socket) > 0) and (string-length($score) > 0)">
                    <xsl:element name="cpu">

                        <xsl:element name="name">
                            <xsl:value-of select="$itemName"/>
                        </xsl:element>
                    
                        <xsl:element name="price">
                            <xsl:value-of select="$price"/>
                        </xsl:element>
                        
                        <xsl:element name="tdp">
                            <xsl:value-of select="$tdp"/>
                        </xsl:element>
                        
                        <xsl:element name="socket">
                            <xsl:value-of select="$socket"/>
                        </xsl:element>
                        
                        <xsl:element name="brand">
                            <xsl:value-of select="$brand"/>
                        </xsl:element>
                            
                        <xsl:element name="score">
                            <xsl:value-of select="$score"/>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    
    <xsl:template name="getTDP">
        <xsl:param name="details"/>
        <xsl:call-template name="getTextDetail">
            <xsl:with-param name="info"  
                            select="$details[contains(xh:td, 'TDP') or contains(xh:td, 'Điện áp') or contains(xh:td, 'thụ')]/xh:td[2]"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getBrand">
        <xsl:param name="details"/>
        <xsl:call-template name="uppercase">
            <xsl:with-param name="str">
                <xsl:call-template name="getTextDetail">
                    <xsl:with-param name="info"  
                                    select="$details[contains(xh:td, 'Thương hiệu') or contains(xh:td, 'Hãng') or contains(xh:td, 'sản xuất')]/xh:td[2]"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="getScore">
        <xsl:param name="itemName"/>
        <xsl:variable name="scoresList" select="document('../../novabench/cpu/ultimate_rs.xml')//n:cpu"/>
        <xsl:value-of select="$scoresList[contains(n:name, $itemName)]/n:score"/>
    </xsl:template>
    
    
   
    
</xsl:stylesheet>
