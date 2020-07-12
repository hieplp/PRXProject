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
            
            <!--Get mainboard summary information-->
            <xsl:variable name="summary" select="xh:div[@class='p-summary']/xh:ul/xh:li"/>
            
            <xsl:variable name="chipset">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Chipset')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="socket">
                <xsl:call-template name="getText">
                    <xsl:with-param name="str" select="$summary[contains(xh:span, 'Socket')]"/>
                    <xsl:with-param name="startChar" select="':'"/>
                    <xsl:with-param name="endChar" select="'-'"/>
                </xsl:call-template>
            </xsl:variable> 
            
            <xsl:if test="(number($price) = $price) and boolean($socket) and boolean($chipset)">
                <xsl:variable name="itemLink" select="xh:a[@class='p-name']/@href"/>
                <xsl:variable name="specs" select="document(concat($host, $itemLink))//*[contains(@class, 'technical-table')]/xh:div/xh:table/xh:tbody/xh:tr"/>
                <!--Get max ram storage--> 
                <xsl:variable name="maxRam">
                    <xsl:call-template name="getRamInfo">
                        <xsl:with-param name="specs" select="$specs"/>
                        <xsl:with-param name="delim" select="'GB'"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--Get max ram slot--> 
                <xsl:variable name="slotRam">
                    <xsl:call-template name="getRamInfo">
                        <xsl:with-param name="specs" select="$specs"/>
                        <xsl:with-param name="delim" select="'x'"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--Get storage interfaces-->
                <xsl:variable name="storageInterfaces" 
                              select="$specs[contains(xh:td[2], 'NVM.E') or contains(xh:td[2], 'M.2') or contains(xh:td[2], 'SATA')]/xh:td"/>
                <!--check if maxRam and slotRam is a number-->
                <xsl:if test="(number($maxRam) = $maxRam) and (number($slotRam) = $slotRam) and boolean($storageInterfaces)">
                    <xsl:element name="mainboard">
                        <xsl:element name="name">
                            <!--remove unnessary inforamtion after '/' and '('--> 
                            <xsl:variable name="itemName" select="translate(xh:a[@class='p-name'], '(', '/')"/>
                            <xsl:choose>
                                <xsl:when test="contains($itemName, '/')">
                                    <xsl:choose>
                                        <xsl:when test="contains($itemName, 'Wifi') or contains($itemName, 'WIFI') or contains($itemName, 'WI-FI')">
                                            <xsl:value-of select="concat(substring-before($itemName, '/'), 'WIFI')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="substring-before($itemName, '/')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
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

                        <xsl:element name="chipset">
                            <xsl:value-of select="$chipset"/>
                        </xsl:element>

                        <xsl:element name="socket">
                            <xsl:value-of select="$socket"/>
                        </xsl:element>
                      
                        <xsl:element name="maxRam">
                            <xsl:value-of select="$maxRam"/>
                        </xsl:element>
                        
                        <xsl:element name="slotRam">
                            <xsl:value-of select="$slotRam"/>
                        </xsl:element>
                        
                        <xsl:element name="interfaces">
                            <xsl:call-template name="getInterfacesSuppport">
                                <xsl:with-param name="interfaces" select="$specs[contains(xh:td[2], 'PCI') or contains(xh:td, 'PCI')]/xh:td"/>
                            </xsl:call-template>
                        </xsl:element>
                        
                        <xsl:element name="storageInterfaces">
                            <xsl:call-template name="getStorageSupport">
                                <xsl:with-param name="storageInterfaces" select="$storageInterfaces"/>
                            </xsl:call-template>
                        </xsl:element>
                        
                    </xsl:element>
                </xsl:if>
                
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="getInterfacesSuppport">
        <xsl:param name="interfaces"/>
             
        <xsl:variable name="str">
            <xsl:for-each select="$interfaces">
                <xsl:value-of select="concat(., ' ')"/>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'x16'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'x16'))"/>
            </xsl:attribute> 
        </xsl:element>
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'x8'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'x8'))"/>
            </xsl:attribute> 
        </xsl:element>  
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'x4'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'x4'))"/>
            </xsl:attribute> 
        </xsl:element>  
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'x1'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, ' x1 '))"/>
            </xsl:attribute> 
        </xsl:element>  
        
    </xsl:template>
    
    <!--Get ram detail information-->
    <xsl:template name="getRamInfo">
        <xsl:param name="specs"/>
        <xsl:param name="delim"/>
        <xsl:variable name="ram">
            <xsl:call-template name="uppercase">
                <xsl:with-param name="str">
                    <xsl:call-template name="getTextDetail">
                        <xsl:with-param name="info" select="$specs[contains(translate(xh:td[2], 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), 'GB')]/xh:td[2]"/>>
                    </xsl:call-template>
                </xsl:with-param> 
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($ram, $delim)">
                <xsl:call-template name="getLastStr">
                    <xsl:with-param name="str" select="normalize-space(substring-before($ram, $delim))"/>
                    <xsl:with-param name="delimiter" select="' '"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="getOnlyNumber">
                    <xsl:with-param name="str" select="normalize-space(substring-before($ram, ' '))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Get storage interfaces-->
    <xsl:template name="getStorageSupport">
        <xsl:param name="storageInterfaces"/>
        <xsl:variable name="str">
            <xsl:for-each select="$storageInterfaces">
                <xsl:value-of select="concat(., '----------')"/>
            </xsl:for-each>
        </xsl:variable>

        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'NVM.e'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'NVM.e'))"/>
            </xsl:attribute> 
        </xsl:element>  
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'SATA'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'SATA'))"/>
            </xsl:attribute> 
        </xsl:element>  
        <xsl:element name="interface">
            <xsl:attribute name="type">
                <xsl:value-of select="'M.2'"/>
            </xsl:attribute>
            <xsl:attribute name="support">
                <xsl:value-of select="boolean(contains($str, 'M.2'))"/>
            </xsl:attribute> 
        </xsl:element>  
    </xsl:template>
    
</xsl:stylesheet>
