<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="server/codegen.server.xslt"/>
  <xsl:import href="client/codegen.client.xslt"/>

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  
    <xsl:template match="/">
    <folder name="weborb-codegen">
      <folder name="server">
        <xsl:call-template name="codegen.server" />
      </folder>
      <folder name="client">
        <folder name="src">
          <xsl:call-template name="codegen.client" />
        </folder>
      </folder>
    </folder>
  </xsl:template>

</xsl:stylesheet>