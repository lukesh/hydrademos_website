<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  <xsl:import href="codegen.invoke.xslt"/>

  <xsl:template name="codegen.invoke.method.name">
    service.<xsl:value-of select="@name"/>
  </xsl:template>

  <xsl:template name="codegen.service">
    <file name="{@name}.as">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.as')" />
      </xsl:call-template>
      <xsl:call-template name="codegen.code" />
    </file>
    <xsl:call-template name="codegen.vo.folder">
      <xsl:with-param name="version" select="2" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="codegen.code">
    import mx.remoting.*;
    import mx.rpc.*;
    import mx.utils.Delegate;
    import <xsl:value-of select="@namespace" />.vo.*;

    var weborbUrl:String = "<xsl:value-of select='@url'/>";
    var service:Service;

    service = new Service(weborbUrl, null, "<xsl:value-of select='@fullname'/>");
    
    <xsl:for-each select="method">
      function <xsl:value-of select="@name"/>(<xsl:for-each select="arg">
        <xsl:if test="position() != 1">,</xsl:if>
        <xsl:value-of select="@name"/>:<xsl:value-of select="@type" />
      </xsl:for-each>)
      {
      var pendingCall:PendingCall = service.<xsl:value-of select="@name"/>(<xsl:for-each select="arg">
        <xsl:if test="position() != 1">,</xsl:if>
        <xsl:value-of select="@name"/>
      </xsl:for-each>);
      pendingCall.responder = new RelayResponder(this, "<xsl:value-of select='@name'/>Handler", "OnErrorHandler");
      }
    </xsl:for-each>

    <xsl:for-each select="method">
      function <xsl:value-of select="@name"/>Handler(event:ResultEvent)
      {
      <xsl:if test="@type != 'void'">
        var returnValue:<xsl:value-of select="@type" /> = <xsl:value-of select="@type" />(event.result);
        trace( "received result - " + returnValue );
      </xsl:if>
      }
    </xsl:for-each>

    <xsl:for-each select="method[@containsvalues=1]">
      function TestDrive():Void
      {
      <xsl:call-template name="codegen.invoke.method" />
      }
    </xsl:for-each>

    function OnErrorHandler( event:FaultEvent )
    {
      trace( event.fault.faultstring );
    }
    
  </xsl:template>

</xsl:stylesheet>
