<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="codegen.client.ui.unittest.create">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="UTest{$class-name}Create.as" override="true" addxmlversion="true">
      package UI.UnitTest
      {
      import weborb.utest.*;
      import <xsl:value-of select="codegen:getClientNamespace()" />.*;
      import mx.rpc.Responder;
      import weborb.data.ActiveRecord;
      import flash.utils.ByteArray;
      import mx.utils.UIDUtil;

      public class UTest<xsl:value-of select="$class-name" />Create extends UnitTest
      {
      protected var <xsl:value-of select="codegen:getFunctionParameter($class-name)" />:<xsl:value-of select="$class-name" />;

      public function UTest<xsl:value-of select="$class-name" />Create (name:String = "<xsl:value-of select="$class-name" /> - Create")
      {
        super(name);
      }

      protected override function onInitialize():void
      {
      <xsl:value-of select="codegen:getFunctionParameter($class-name)" /> = new <xsl:value-of select="$class-name" />();

      <xsl:for-each select="xs:complexType/xs:attribute[not(@msdata:AutoIncrement='true')]">
        <xsl:variable name="attribute-name" select="@name" />
        <xsl:variable name="property" select="codegen:getPropertyName($table,@name)" />
        
        <xsl:if test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
          <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.<xsl:value-of select="codegen:getPropertyName($table,@name)"/> = <xsl:value-of select="codegen:getPrimitiveValue(@type)"/>;
        </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="xs:keyref">
      <xsl:variable name="relationName" select="codegen:getParentProperty($table,key('table',@refer)/@name,@name,0)" />
      <xsl:for-each select="key('table',@refer)">
        ActiveRecords.<xsl:value-of select="codegen:getClassName(@name)"/>.findFirst().addResponder(
              new Responder(on<xsl:value-of select="$relationName" />Received,onFault));
        </xsl:for-each>
      </xsl:for-each>
     }

      protected override function getPartsCount():int
      {
        return <xsl:value-of select="count(xs:keyref)" />;
      }

      protected override function onExecute():void
      {
        <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.save().addResponder(new Responder(onSaved,onFault));
      }

      protected virtual function onSaved(activeRecord:ActiveRecord):void
      {
      raiseOnResult();
      }
      
      <xsl:for-each select="xs:keyref">
        <xsl:variable name="relationName" select="codegen:getParentProperty($table,key('table',@refer)/@name,@name,0)" />
        <xsl:for-each select="key('table',@refer)">
          protected function on<xsl:value-of select="$relationName" />Received(<xsl:value-of select="codegen:getFunctionParameter($relationName)"/>:<xsl:value-of select="codegen:getClassName(@name)"/>):void
          {
            <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.<xsl:value-of select="$relationName"/> = <xsl:value-of select="codegen:getFunctionParameter($relationName)"/>;

            onPartReceived(<xsl:value-of select="codegen:getFunctionParameter($relationName)"/>);
          }
        </xsl:for-each>
      </xsl:for-each>
      
      }
      }
   </file>
  </xsl:template>
</xsl:stylesheet>