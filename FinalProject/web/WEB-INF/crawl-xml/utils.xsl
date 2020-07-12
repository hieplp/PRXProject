<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : utils.xsl
    Created on : July 7, 2020, 11:56 PM
    Author     : hiepp
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:xh="http://www.w3.org/1999/xhtml">
    <!--<xsl:output method="html"/>-->

    <!--Convert lowercase to uppercase-->
    <xsl:template name="uppercase">
        <xsl:param name="str"/>
        <xsl:value-of select="translate($str, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
    </xsl:template>
    
    <!--Get only number character from a string-->
    <xsl:template name="getOnlyNumber">
        <xsl:param name="str"/>
        <xsl:value-of select="translate($str, translate($str, '0123456789', ''), '')"/>
    </xsl:template>
    
    <!--Get only number character from a string-->
    <xsl:template name="getOnlyChar">
        <xsl:param name="str"/>
        <xsl:value-of select="translate($str, translate($str, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', ''), '')"/>
    </xsl:template>
    
    <!--Get last parameter with delimiter-->
    <xsl:template name="getLastStr">
        <xsl:param name="str"/>
        <xsl:param name="delimiter"/>
        <xsl:choose>
            <xsl:when test="contains($str, $delimiter)">
                <xsl:call-template name="getLastStr">
                    <xsl:with-param name="str" select="normalize-space(substring-after($str, $delimiter))"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--get list item-->
    <xsl:template name="while">
        <xsl:param name="currentLink"/>
        <xsl:param name="host"/>
        <xsl:variable name="listDoc" select="document($currentLink)"/>
        <xsl:variable name="lastLink" select="($listDoc//*[@class='paging']/xh:a)[last()]"/>
        <xsl:choose>
            <xsl:when test="contains($lastLink, 'next')">
                <xsl:variable name="nextLink" select="concat($host, $lastLink/@href)"/>
                <xsl:variable name="items" select="$listDoc//*[@class='p-item']/xh:div"/>

                <xsl:call-template name="itemDetailList">
                    <xsl:with-param name="items" select="$items"/>
                    <xsl:with-param name="host" select="$host"/>
                </xsl:call-template>
                
                <!--Call template again to get next page-->
                <xsl:if test="$items">
                    <xsl:call-template name="while">
                        <xsl:with-param name="currentLink" select="$nextLink"/>
                        <xsl:with-param name="host" select="$host"/>
                    </xsl:call-template>
                </xsl:if>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$listDoc//*[@class='paging']/xh:a">
                    <xsl:variable name="items" select="document(concat($host, @href))//*[@class='p-item']/xh:div"/>
                    <xsl:call-template name="itemDetailList">
                        <xsl:with-param name="items" select="$items"/>
                        <xsl:with-param name="host" select="$host"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Get text between 2 characters-->
    <xsl:template name="getTextBetween2Chars">
        <xsl:param name="str"/>
        <xsl:param name="startChar"/>
        <xsl:param name="endChar"/>
        <xsl:param name="status"/>
        
        <xsl:choose>
            <xsl:when test="$status = 'END'">
                <xsl:value-of select="normalize-space(substring-before($str, $endChar))"/>
            </xsl:when>
            <xsl:otherwise>
                <!--remove text before startChar then call getTextBetween2Chars again to remove text after endChar-->
                <xsl:call-template name="getTextBetween2Chars">
                    <xsl:with-param name="str" select="substring-after($str, $startChar)"/>
                    <xsl:with-param name="endChar" select="$endChar"/>
                    <xsl:with-param name="status" select="'END'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--Get text between 2 characters-->
    <xsl:template name="getText">
        <xsl:param name="str"/>
        <xsl:param name="startChar"/>
        <xsl:param name="endChar"/>
        <xsl:param name="status"/>
        
        <xsl:choose>
            <xsl:when test="$status = 'END'">
                <!--if contains endChar then get text before, if do nothing-->
                <xsl:choose>
                    <xsl:when test="contains($str, $endChar)">
                        <xsl:value-of select="normalize-space(substring-before($str, $endChar))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space($str)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!--remove text before startChar then call getText again to remove text after endChar-->
                <xsl:call-template name="getText">
                    <xsl:with-param name="str">
                        <!--if contains startChar then get text after if do nothing-->
                        <xsl:choose>
                            <xsl:when test="contains($str, $startChar)">
                                <xsl:value-of select="substring-after($str, $startChar)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$str"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param> 
                    <xsl:with-param name="endChar" select="$endChar"/>
                    <xsl:with-param name="status" select="'END'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="getTextDetail">
        <xsl:param name="info"/>
        <xsl:choose>
            <xsl:when test="$info/xh:p">
                <xsl:value-of select="$info/xh:p"/>
            </xsl:when>
            <xsl:when test="$info/xh:span">
                <xsl:value-of select="$info/xh:span"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$info"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--    <xsl:template name="while">
        <xsl:param name="currentPage"/>
        <xsl:param name="link"/>
        <xsl:param name="host"/>
        <xsl:variable name="currentLink" select="concat($link, $currentPage)"/>
        <xsl:variable name="items" select="document($currentLink)//*[contains(@class, 'tr__product')]"/>
        <xsl:if test="$items">
            <xsl:call-template name="itemList">
                <xsl:with-param name="items" select="$items"/>
                <xsl:with-param name="host" select="$host"/>
            </xsl:call-template>
            <xsl:call-template name="while">
                <xsl:with-param name="currentPage" select="number($currentPage) + 1"/>
                <xsl:with-param name="link" select="$link"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>-->
    
</xsl:stylesheet>
