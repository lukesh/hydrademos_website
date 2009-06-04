<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="codegen.client.ui.unittest.app">
    <file name="UnitTests.mxml" override="true" type="xml" addxmlversion="true">
      <mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:ns1="weborb.utest.*" creationComplete="onCreationComplete()">
        <mx:Script>
          &lt;![CDATA[
          import UI.UnitTest.*;
          import weborb.utest.UnitTestEngine;

          private function onCreationComplete():void
          {
          var unitTestEngine:UnitTestEngine = new UnitTestEngine();

          <xsl:for-each select="/xs:schema/xs:element/xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
            unitTestEngine.items.addItem(new UTest<xsl:value-of select="codegen:getClassName(@name)" />Create());
            unitTestEngine.items.addItem(new UTest<xsl:value-of select="codegen:getClassName(@name)" />Update());
            unitTestEngine.items.addItem(new UTest<xsl:value-of select="codegen:getClassName(@name)" />FindLast());
            unitTestEngine.items.addItem(new UTest<xsl:value-of select="codegen:getClassName(@name)" />FindFirst());
            unitTestEngine.items.addItem(new UTest<xsl:value-of select="codegen:getClassName(@name)" />Delete());
          </xsl:for-each>

          unitTestView.engine = unitTestEngine;
          }
          ]]&gt;
        </mx:Script>
        <ns1:UnitTestView width="100%" height="100%" id="unitTestView" />
      </mx:Application>
    </file>
  </xsl:template>
</xsl:stylesheet>