<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  <xsl:import href="codegen.invoke.ajax.xslt"/>

  <xsl:template name="codegen.invoke.method.name">
    <xsl:value-of select="@name"/>
  </xsl:template>
  
  <xsl:template name="codegen.service">
    <file name="{@name}.js">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.js')" />
      </xsl:call-template>
      
      <xsl:for-each select="datatype">
        function <xsl:value-of select="@name"/>()
        {
          <xsl:for-each select="field">
            this.<xsl:value-of select="@name"/> = <xsl:choose>
              <xsl:when test="@type='String'">''</xsl:when>
              <xsl:when test="@type='Boolean'">false</xsl:when>
              <xsl:when test="@type='Date'">new Date()</xsl:when>
              <xsl:when test="@type='int' or @type = 'Number'">0</xsl:when>
              <xsl:when test="@type='Array'">new Array()</xsl:when>
              <xsl:otherwise>null</xsl:otherwise>
            </xsl:choose>;
          </xsl:for-each>
        }
      </xsl:for-each>
     
      <xsl:call-template name="codegen.code" />
    </file>
  </xsl:template>
  <xsl:template name="codegen.code">
    var proxy = webORB.bind( "<xsl:value-of select='@fullname' />", "<xsl:value-of select='@url' />" );
    
    <xsl:for-each select='method'>
      function <xsl:value-of select='@name'/>( <xsl:for-each select="arg">
      <xsl:if test="position() != 1">,</xsl:if>
      <xsl:value-of select="@name"/>
    </xsl:for-each><xsl:if test="count(arg) != 0">,</xsl:if> weborbAsyncCall )
      {
        if( weborbAsyncCall )
          proxy.<xsl:value-of select='@name'/>( <xsl:for-each select="arg">
      <xsl:if test="position() != 1">,</xsl:if>
      <xsl:value-of select="@name"/>
    </xsl:for-each><xsl:if test="count(arg) != 0">,</xsl:if> new Async( <xsl:value-of select='@name'/>Response ) );
        else
          return proxy.<xsl:value-of select='@name'/>(<xsl:for-each select="arg">
      <xsl:if test="position() != 1">,</xsl:if>
      <xsl:value-of select="@name"/>
    </xsl:for-each>);
      }
    </xsl:for-each>
    <xsl:for-each select='method'>
      function <xsl:value-of select='@name'/>Response( result )
      {
         alert( result );
      }
    </xsl:for-each>


    <xsl:for-each select="method[@containsvalues=1]">
      function TestDrive()
      {
        <xsl:call-template name="codegen.invoke.method" />
      }
    </xsl:for-each>

  </xsl:template>

</xsl:stylesheet>
