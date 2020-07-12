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
    <xsl:import  href="../../utils.xsl"/>
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="t:rams">
        <xsl:variable name="listDoc" select="document(@link)"/>
        <!--        <xsl:variable name="link" select="@link"/>-->
        <xsl:element name="rams">
            <xsl:call-template name="while">
                <xsl:with-param name="currentLink" select="@link"/>
                <xsl:with-param name="host" select="@host"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template name="itemDetailList">
        <xsl:param name="items"/>
        <xsl:for-each select="$items">
            <xsl:variable name="name" select="xh:a[@class='p-name']"/>
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            <xsl:variable name="summary" select="xh:div[@class='p-summary']/xh:ul/xh:li"/>
            
            <xsl:variable name="storage" >
                <xsl:call-template name="getText">
                    <xsl:with-param name="str">
                        <xsl:call-template name="uppercase">
                            <xsl:with-param name="str" select="$summary[contains(xh:span, 'Dung lượng')]"/>
                        </xsl:call-template>
                    </xsl:with-param> 
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="type">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'DDR')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable> 
            
            <!--remove ram for laptop-->
            <xsl:if test="not(contains($name, 'note') or contains($name, 'Note')) and (number($price) = $price) and boolean($storage) and boolean($type)">
                <xsl:variable name="quantity">
                    <xsl:choose>
                        <xsl:when test="contains($storage, 'X')">
                            <xsl:call-template name="getTextBetween2Chars">
                                <xsl:with-param name="str" select="$storage"/>
                                <xsl:with-param name="startChar" select="'('"/>
                                <xsl:with-param name="endChar" select="'X'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains($storage, '*')">
                            <xsl:call-template name="getTextBetween2Chars">
                                <xsl:with-param name="str" select="$storage"/>
                                <xsl:with-param name="startChar" select="'('"/>
                                <xsl:with-param name="endChar" select="'*'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'1'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:variable name="singleStorage">
                    <xsl:choose>
                        <xsl:when test="contains($storage, 'X')">
                            <xsl:call-template name="getTextBetween2Chars">
                                <xsl:with-param name="str" select="$storage"/>
                                <xsl:with-param name="startChar" select="'X'"/>
                                <xsl:with-param name="endChar" select="'GB'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="contains($storage, '*')">
                            <xsl:call-template name="getTextBetween2Chars">
                                <xsl:with-param name="str" select="$storage"/>
                                <xsl:with-param name="startChar" select="'*'"/>
                                <xsl:with-param name="endChar" select="'GB'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="getOnlyNumber">
                                <xsl:with-param name="str" select="$storage"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:if test="(number($quantity) = $quantity) and (number($singleStorage) = $singleStorage)">
                    <xsl:element name="ram">
                    
                        <xsl:element name="name">
                            <xsl:value-of select="$name"/>
                        </xsl:element>
                    
                        <xsl:element name="price">
                            <xsl:value-of select="$price"/>
                        </xsl:element>
                    
                        <xsl:element name="type">
                            <xsl:value-of select="$type"/>
                        </xsl:element>
                    
                        <xsl:element name="storage">
                            <xsl:element name="quantity">
                                <xsl:value-of select="$quantity"/>
                            </xsl:element>
                            <xsl:element name="singleStorage">
                                <xsl:value-of select="$singleStorage"/>
                            </xsl:element>
                        </xsl:element>
                        
                        <xsl:element name="bus">
                            <xsl:call-template name="getText">
                                <xsl:with-param name="str">
                                    <xsl:call-template name="getOnlyNumber">
                                        <xsl:with-param name="str" select="$summary[contains(xh:span, 'Bus')]"/>
                                    </xsl:call-template>
                                </xsl:with-param> 
                                <xsl:with-param name="startChar" select="':'"/>
                                <xsl:with-param name="endChar" select="'-'"/>
                            </xsl:call-template>
                           
                        </xsl:element>
                    </xsl:element> 
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
