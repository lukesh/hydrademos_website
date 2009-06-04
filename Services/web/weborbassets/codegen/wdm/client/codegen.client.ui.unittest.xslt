<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"   
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="codegen.client.ui.unittest.create.xslt"/>
  <xsl:import href="codegen.client.ui.unittest.update.xslt"/>
  <xsl:import href="codegen.client.ui.unittest.delete.xslt"/>
  <xsl:import href="codegen.client.ui.unittest.findfirst.xslt"/>
  <xsl:import href="codegen.client.ui.unittest.findlast.xslt"/>

  <xsl:template name="codegen.client.ui.unittest">
    <xsl:call-template name="codegen.client.ui.unittest.create" />
    <xsl:call-template name="codegen.client.ui.unittest.update" />
    <xsl:call-template name="codegen.client.ui.unittest.delete" />
    <xsl:call-template name="codegen.client.ui.unittest.findfirst" />
    <xsl:call-template name="codegen.client.ui.unittest.findlast" />
  </xsl:template>
  
</xsl:stylesheet>