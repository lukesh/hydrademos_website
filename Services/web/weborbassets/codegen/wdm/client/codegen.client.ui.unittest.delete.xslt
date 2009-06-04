<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"   
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="codegen.client.ui.unittest.delete">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="UTest{$class-name}Delete.as" override="true" addxmlversion="true">
      package UI.UnitTest
      {
      import weborb.data.ActiveRecord;
      import mx.rpc.Responder;

      public class UTest<xsl:value-of select="$class-name" />Delete extends UTest<xsl:value-of select="$class-name" />Create
      {
        public function UTest<xsl:value-of select="$class-name" />Delete()
        {
          super("<xsl:value-of select="$class-name" /> - Delete");
      }

      
      protected override function onSaved(activeRecord:ActiveRecord):void
      {
      activeRecord.remove(true,new Responder(
      function(removedActiveRecord:ActiveRecord):void
      {
      raiseOnResult();

      },onFault));

      }
      }

      }
    </file>
    </xsl:template>
</xsl:stylesheet>