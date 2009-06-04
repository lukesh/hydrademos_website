<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="codegen.client.ui.unittest.findfirst">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="UTest{$class-name}FindFirst.as" override="true" addxmlversion="true">
      package UI.UnitTest
      {
      import weborb.utest.UnitTest;
      import <xsl:value-of select="codegen:getClientNamespace()" />.*;
      import mx.rpc.Responder;

      public class UTest<xsl:value-of select="$class-name"/>FindFirst extends UnitTest
      {

      public function UTest<xsl:value-of select="$class-name"/>FindFirst()
      {
        super("<xsl:value-of select="$class-name"/> - FindFirst");
      }

      protected override function onExecute():void
      {
        ActiveRecords.<xsl:value-of select="$class-name"/>.findFirst().addResponder(
        new Responder(
        function(item:<xsl:value-of select="$class-name"/>):void
        {
          raiseOnResult();
        },
        onFault));
      }
      }
      }
    </file>
  </xsl:template>
</xsl:stylesheet>