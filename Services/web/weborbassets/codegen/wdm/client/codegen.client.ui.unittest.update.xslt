<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="codegen.client.ui.unittest.update">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="UTest{$class-name}Update.as" override="true" addxmlversion="true">
      package UI.UnitTest
      {
      import weborb.utest.*;
      import <xsl:value-of select="codegen:getClientNamespace()" />.*;
      import mx.rpc.Responder;
      import weborb.data.ActiveRecord;
      
	    public class UTest<xsl:value-of select="$class-name"/>Update extends UnitTest
	    {
		    private var <xsl:value-of select="codegen:getFunctionParameter($class-name)"/>:<xsl:value-of select="$class-name"/>;
    		
		    public function UTest<xsl:value-of select="$class-name"/>Update()
		    {
			    super("<xsl:value-of select="$class-name"/> - Update");
		    }
    					
		    protected override function onInitialize():void
		    {
			    ActiveRecords.<xsl:value-of select="$class-name"/>.findFirst().addResponder(
				    new Responder(on<xsl:value-of select="$class-name"/>Received,onFault));
		    }
    		
		    private function on<xsl:value-of select="$class-name"/>Received(item:<xsl:value-of select="$class-name"/>):void
		    {
			    this.<xsl:value-of select="codegen:getFunctionParameter($class-name)"/> = item;
    			
			    onPartReceived(item);
		    }
    		
		    protected override function getPartsCount():int
		    {
			    return 1;
		    }
    		
		    protected override function onExecute():void
		    {
			    <xsl:value-of select="codegen:getFunctionParameter($class-name)"/>.save().addResponder(new Responder(
				    function(activeRecord:ActiveRecord):void
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