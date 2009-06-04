<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="codegen.client.ui.unittest.findlast">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="UTest{$class-name}FindLast.as" override="true" addxmlversion="true">
      package UI.UnitTest
      {
      import weborb.utest.UnitTest;
      import <xsl:value-of select="codegen:getClientNamespace()" />.*;
      import mx.rpc.Responder;

      public class UTest<xsl:value-of select="$class-name"/>FindLast extends UnitTest
      {

      public function UTest<xsl:value-of select="$class-name"/>FindLast()
      {
      super("<xsl:value-of select="$class-name"/> - FindLast");
      }

      protected override function onExecute():void
      {
      ActiveRecords.<xsl:value-of select="$class-name"/>.findLast().addResponder(
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