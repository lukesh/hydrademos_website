<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codegen="urn:cogegen-xslt-lib:xslt">

  <xsl:import href="codegen.xslt"/>
  <xsl:import href="codegen.invoke.xslt"/>

  <xsl:template name="comment.service">
    /***********************************************************************
    The generated code provides a simple mechanism for invoking methods
    from the <xsl:value-of select="@fullname" /> class using WebORB Silverlight. 
    client API.
    The generated files can be added to a Visual Studio 2008 Silverlight library 
    project. You can compile the library and use it from other Silverlight
    component projects.
    ************************************************************************/
  </xsl:template>
  
  <xsl:template name="codegen.root">
    <xsl:call-template name="codegen.instructions" />
  </xsl:template>
   
  <xsl:template name="codegen.service">
      <file name="{@name}Service.cs">
        <xsl:call-template name="codegen.code" />
      </file>
      <file name="I{@name}.cs">
        <xsl:call-template name="codegen.interface" />
      </file>
      <file name="{@name}Model.cs">
        <xsl:call-template name="codegen.model" />
      </file>
     <xsl:call-template name="codegen.sl.datatypes" />
  </xsl:template>

  <xsl:template name="codegen.sl.datatypes">
    <xsl:param name="version" select="3" />    
    <xsl:if test="count(datatype) != 0">
      <folder name="types">
        <xsl:for-each select="datatype">
          <xsl:call-template name="codegen.sl.vo">
            <xsl:with-param name="version" select="$version" />
          </xsl:call-template>
        </xsl:for-each>
      </folder>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="codegen.sl.vo">
    <file name="{@name}.cs">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.cs')" />
      </xsl:call-template>
        namespace <xsl:value-of select="//service/@namespace" />
        {
        public class <xsl:value-of select="@name"/>
        {
        <xsl:for-each select="field">
          public <xsl:value-of select="@nativetype"/><xsl:text> </xsl:text><xsl:value-of select="@name"/>;
        </xsl:for-each>
        }
      }
    </file>
  </xsl:template>  
  
  <xsl:template name="codegen.invoke.method.name">
    m_service.<xsl:value-of select="@name"/>
  </xsl:template>
  

  <xsl:template name="codegen.code">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat(concat(@name,'Service'),'.cs')" />
    </xsl:call-template>
    <xsl:call-template name="comment.service" />
    using System.Collections;
    using System.Collections.Generic;
    using Weborb.Client;
    
    namespace <xsl:value-of select="@namespace" />
    {
    public class <xsl:value-of select="@name"/>Service
    {
      private WeborbClient weborbClient;
      private <xsl:value-of select="concat('I',@name)" /> proxy;
      private <xsl:value-of select="@name"/>Model model;

      public <xsl:value-of select="@name"/>Service() : this( new <xsl:value-of select="@name"/>Model() )
      {
      }
      
      public <xsl:value-of select="@name"/>Service( <xsl:value-of select="@name"/>Model model )
      {
        this.model = model
        weborbClient = new WeborbClient("weborb.aspx"); 
        proxy = weborbClient.Bind&lt;<xsl:value-of select="concat('I',@name)" />&gt;();
      }

      public <xsl:value-of select="@name"/>Model GetModel()
      {
        return this.model;
      }
    <xsl:for-each select="method">
      public AsyncToken&lt;<xsl:value-of select="@nativetype" />&gt;<xsl:text> </xsl:text><xsl:value-of select="@name"/>( <xsl:for-each select="arg"><xsl:value-of select="@nativetype" /><xsl:text> </xsl:text><xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if><xsl:text> </xsl:text></xsl:for-each> )
      {<xsl:choose>
        <xsl:when test="@type != 'void'">
            AsyncToken&lt;<xsl:value-of select="@nativetype" />&gt;<xsl:text> </xsl:text> asyncToken = proxy.<xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:if test="position() != 1">,</xsl:if><xsl:value-of select="@name"/></xsl:for-each>);
            asyncToken.ResultListener += <xsl:value-of select="@name" />ResultHandler;
            return asyncToken;
      </xsl:when>
        <xsl:otherwise>
            proxy.<xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:if test="position() != 1">,</xsl:if><xsl:value-of select="@name"/></xsl:for-each>);
      </xsl:otherwise>
</xsl:choose>}
    </xsl:for-each>
    
    <xsl:for-each select="method">     
     <xsl:if test="@type != 'void'">
      void <xsl:value-of select="@name" />ResultHandler(<xsl:value-of select="@nativetype" /> result)
      {
        model.<xsl:value-of select="@name" />Result = returnValue;
      }</xsl:if>
    </xsl:for-each>
      public function onFault (event:FaultEvent):void
      {
        Alert.show(event.fault.faultString, "Error");
      }
    }
  } 
  </xsl:template>
  
  <xsl:template name="codegen.interface">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat('I',concat(@name,'.cs'))" />
    </xsl:call-template>
    using System.Collections;
    using System.Collections.Generic;
    using Weborb.Client;

    namespace <xsl:value-of select="@namespace" />
    {
      public interface I<xsl:value-of select="@name"/>
      {<xsl:for-each select="method">
        <xsl:choose>
            <xsl:when test="@type != 'void'">
                AsyncToken&lt;<xsl:value-of select="@nativetype" />&gt; <xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:value-of select="concat(@nativetype, ' ')" /> <xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>);
      </xsl:when>
            <xsl:otherwise>
                void <xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:value-of select="concat(@nativetype, ' ')" /> <xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>);
            </xsl:otherwise>
    </xsl:choose>
    </xsl:for-each>}
  } 
  </xsl:template>
  
  <xsl:template name="codegen.model">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat(@name,'Model.cs')" />
    </xsl:call-template>
    
    <xsl:if test="//datatype">
      using <xsl:value-of select="@namespace" />.vo.*;
    </xsl:if>    
    namespace <xsl:value-of select="@namespace" />
    { 
      public class <xsl:value-of select="@name"/>Model
      {<xsl:for-each select="method"><xsl:if test="@type != 'void'">     
        public <xsl:value-of select="@nativetype" /><xsl:text> </xsl:text><xsl:value-of select="@name" />Result;</xsl:if></xsl:for-each>
      }
    }
  </xsl:template>
  
  <xsl:template name="codegen.instructions">
  <xsl:param name="file-name" select="codegen:getServiceName()"/>
    <file name="{$file-name}-instructions.txt" overwrite="false">
      The generated code enables remoting operations between a Silverlight client and the 
      selected service (<xsl:value-of select="$file-name"/>).
      
      Generated classes include:
      
      1. Service facade (<xsl:value-of select="//service/@namespace" />.<xsl:value-of select="$file-name"/>Service) - Contains the same 
          methods as the remote service. Includes functionality for creating a proxy, handling 
          RPC invocations and updating the model.
          
      2. Model class (<xsl:value-of select="//service/@namespace" />.<xsl:value-of select="$file-name"/>Model) - Contains properties 
         updated by the Service facade when it receives results from the remote method invocations.
          
      3. Remote service interface (<xsl:value-of select="//service/@namespace" />.I<xsl:value-of select="$file-name"/>) - An interface 
          with the same methods as the remote service, but modified return values to reflect 
          the asynchronous nature of the client/server invocations.
    </file>
  </xsl:template>  
</xsl:stylesheet>
