<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.server.csharp.domain.xslt"/>
  <xsl:import href="data/codegen.server.csharp.data.xslt"/>


  <xsl:template name="codegen.server.csharp.config">
    <file name="App.Config" overwrite="false" type="xml" addxmlversion="true" >
      <configuration>
        <connectionStrings>
          <xsl:for-each select="/xs:schema/xs:element">
            <add name="{@name}" connectionString="{codegen:getConnectionString(@name)}" />          
          </xsl:for-each>
        </connectionStrings>
      </configuration>
    </file>
  </xsl:template>
</xsl:stylesheet>