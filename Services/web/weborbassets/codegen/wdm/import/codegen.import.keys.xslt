<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:key/xs:field" name="pk" use="../../@name"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:key/xs:field" name="pkByElementId" use="../../@id"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:key/xs:field" name="pkByName" use="../@name"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:keyref/xs:field" name="fk" use="../../@name"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:keyref/xs:field" name="fkByElementId" use="../../@id"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element/xs:keyref/xs:field" name="fkByName" use="../@name"/>
  
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element" name="table" use="xs:key/@name"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element" name="tableByName" use="@name"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element" name="dependent" use="xs:keyref/@refer"/>
  <xsl:key match="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element" name="tableById" use="@id"/>



  <xsl:template name="parent-path">
    <xsl:param name="field" />
    <xsl:param name="table" />
    <xsl:if test="key('fk',$table)/@xpath = concat('@',$field)">
      <xsl:variable name="parent-table" select="key('table', key('tableByName',$table)/xs:keyref[xs:field[@xpath=concat('@',$field)]]/@refer)/@name" />
      .<xsl:value-of select="codegen:getPropertyName( $parent-table )"/>
      <xsl:call-template name="parent-path">
        <xsl:with-param name="field" select="$field" />
        <xsl:with-param name="table" select="$parent-table" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>