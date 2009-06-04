<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="csharp/codegen.server.csharp.xslt"/>
  <xsl:import href="csharp/codegen.server.csharp.project.xslt"/>
  <xsl:import href="vb/codegen.server.vb.project.xslt"/>
  
  <xsl:template name="codegen.server">
    <xsl:variable name="lang" select="codegen:getServerLanguage()" />
    <xsl:value-of select="codegen:Progress('Server code generator started')" />
    <xsl:value-of select="codegen:Progress(concat('Server code language is ', $lang))" />
    
    <xsl:choose>
      <xsl:when test="$lang = 'csharp'">
        <xsl:call-template name="codegen.server.csharp" />
        <xsl:call-template name="codegen.server.csharp.project" />
      </xsl:when>
      <xsl:when test="$lang = 'vb'">
        <xsl:call-template name="codegen.server.csharp" />
        <xsl:call-template name="codegen.server.vb.project" />
      </xsl:when>
      <xsl:when test="$lang = ''">
        <xsl:message terminate="yes">
          Server side language "<xsl:value-of select="$lang" />" not defined
        </xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">Server side language "<xsl:value-of select="$lang" />" not supported</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>