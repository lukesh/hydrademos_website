<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.client.domain.xslt" />
  <xsl:import href="codegen.client.ui.testdrive.xslt" />
  <xsl:import href="codegen.client.ui.testdrive.add.xslt" />
  <xsl:import href="codegen.client.ui.unittest.xslt" />
  <xsl:import href="codegen.client.ui.unittest.app.xslt" />

  <xsl:template name="codegen.client">
    <folder name="{codegen:getClientFolder()}">
      <folder name="Codegen">
        <xsl:for-each select="/xs:schema/xs:element">
          <xsl:value-of select="codegen:setCurrentDatabase(@name)" />
          
          <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
            <xsl:call-template name="codegen.client.domain.codegen" />
          </xsl:for-each>
          
          <xsl:call-template name="codegen.client.domain.codegen.datamapperregistry" />
          
        </xsl:for-each>
      </folder>
      <xsl:for-each select="/xs:schema/xs:element">
        <xsl:value-of select="codegen:setCurrentDatabase(@name)" />

        <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
          <xsl:call-template name="codegen.client.domain" />
        </xsl:for-each>
        
        <xsl:call-template name="codegen.client.domain.datamapperregistry" />
        <xsl:call-template name="codegen.client.domain.activerecords" />

      </xsl:for-each>
    </folder>
    <xsl:if test="codegen:IsGenerateTestDrive() or codegen:IsGenerateUnitTests()">
      <folder name="UI">
        <xsl:if test="codegen:IsGenerateTestDrive()">
          <folder name="TestDrive">
            <xsl:for-each select="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
              <xsl:call-template name="codegen.client.ui.testdrive" />
              <xsl:call-template name="codegen.client.ui.testdrive.add" />
            </xsl:for-each>
            <xsl:for-each select="/xs:schema/xs:element">
              <xsl:call-template name="codegen.client.ui.testdrive.databaseview" />
            </xsl:for-each>
          </folder>
        </xsl:if>
        <xsl:if test="codegen:IsGenerateUnitTests()">
          <folder name="UnitTest">
            <xsl:for-each select="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
              <xsl:call-template name="codegen.client.ui.unittest" />
            </xsl:for-each>
          </folder>
        </xsl:if>
      </folder>
    </xsl:if>
    
    <xsl:if test="codegen:IsGenerateUnitTests()">
      <xsl:call-template name="codegen.client.ui.unittest.app" />
    </xsl:if>

    <xsl:if test="codegen:IsGenerateTestDrive()">
      <xsl:call-template name="codegen.client.ui.app" />
    </xsl:if>
    
  </xsl:template>
</xsl:stylesheet>