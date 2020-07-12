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
    
    <xsl:template match="t:hdds">
        <xsl:element name="hdds">
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
            
            <xsl:variable name="capacity">
                <xsl:call-template name="uppercase">
                    <xsl:with-param name="str">
                        <xsl:call-template name="getText">
                            <xsl:with-param name="str" select="$summary[contains(xh:span, 'Dung lượng')]"/>
                            <xsl:with-param name="startChar" select="':'"/>
                            <xsl:with-param name="endChar" select="'-'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="interface">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Chuẩn giao tiếp')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="speed">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Tốc độ')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
           
            
            <xsl:variable name="price" select="translate(xh:span[@class='p-price'], '.', '')"/>
            
            <xsl:variable name="link" select="concat($host, xh:a[@class='p-name']/@href)"/>
            
            <xsl:if test="(number($price) = $price) and (string-length($capacity) > 0) and (string-length($interface) > 0) and (string-length($speed) > 0)">
                
                <xsl:element name="hdd">
                    <xsl:element name="name">
                        <xsl:value-of select="xh:a[@class='p-name']"/>
                    </xsl:element>
                   
                    <xsl:element name="capacity">
                        <xsl:element name="type">
                            <xsl:call-template name="getOnlyChar">
                                <xsl:with-param name="str" select="$capacity"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:element name="quantity">
                            <xsl:call-template name="getOnlyNumber">
                                <xsl:with-param name="str" select="$capacity"/>
                            </xsl:call-template>
                        </xsl:element>
                    </xsl:element>
                      
                    <xsl:element name="image">
                        <xsl:value-of select="concat($host, xh:a[@class='p-img']/xh:img/@data-src)"/>
                    </xsl:element>
                    
                    <xsl:element name="price">
                        <xsl:value-of select="$price"/>
                    </xsl:element>
                    
                    <xsl:element name="interface">
                        <xsl:value-of select="$interface"/>
                    </xsl:element>
                    
                    <xsl:element name="speed">
                        <xsl:call-template name="getOnlyNumber">
                            <xsl:with-param name="str" select="$speed"/>
                        </xsl:call-template>
                    </xsl:element>
                    
                </xsl:element> 
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
