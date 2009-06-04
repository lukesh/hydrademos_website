<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />


  <xsl:template name="codegen.code" />
  <xsl:template name="codegen.root" />  
  <xsl:template name="codegen.info" />
  <xsl:template name="codegen.file.comment" />  
  
  <xsl:template match="/">
    <folder name="weborb-codegen">
      <info>
        <xsl:call-template name="codegen.info" />
      </info>
      <xsl:call-template name="codegen.root" />            
      <xsl:call-template name="codegen.process.namespace" />
    </folder>
  </xsl:template>

  <xsl:template name="codegen.process.namespace">
    <xsl:for-each select="namespace">
      <folder name="{@name}">       
        <xsl:call-template name="codegen.process.namespace" />
        <xsl:for-each select="service">
          <xsl:call-template name="codegen.service" />
        </xsl:for-each>
      </folder>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="codegen.vo">
    <xsl:param name="version" select="3" />
    
    <file name="{@name}.as">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.as')" />
      </xsl:call-template>
      <xsl:if test="$version=3">
        package <xsl:value-of select="//service/@namespace" />.vo
        {
        import mx.collections.ArrayCollection;
        
        [Bindable]
        [RemoteClass(alias="<xsl:value-of select='@fullname'/>")]
      </xsl:if>
      <xsl:if test='$version=3'>  public</xsl:if> class <xsl:choose>
          <xsl:when test='$version=3'>
            <xsl:value-of select="@name"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="//service/@namespace"/>.vo.<xsl:value-of select="@name"/>
          </xsl:otherwise></xsl:choose>
        {
          public function <xsl:value-of select="@name"/>(){}
        
        <xsl:for-each select="field">
          public var <xsl:value-of select="@name"/>:<xsl:value-of select="@type"/>;
        </xsl:for-each>
        }
      <xsl:if test="$version=3">
      }
      </xsl:if>
    </file>
  </xsl:template>

  <xsl:template name="codegen.vo.folder">
    <xsl:param name="version" select="3" />
    
    <xsl:if test="count(datatype) != 0">
      <folder name="vo">
        <xsl:for-each select="datatype">
          <xsl:call-template name="codegen.vo">
            <xsl:with-param name="version" select="$version" />
          </xsl:call-template>
        </xsl:for-each>
      </folder>
    </xsl:if>
  </xsl:template>
  <xsl:template name="codegen.service">
    <xsl:call-template name="codegen.vo.folder" />

    <file name="{concat(@name,'.as')}">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'.as')" />
      </xsl:call-template>
      <xsl:call-template name="codegen.code" />         
    </file>
  </xsl:template>

  <xsl:template name="codegen.description">
    <xsl:param name="file-name" />
    /*******************************************************************
    * <xsl:value-of select="$file-name" />
    * Copyright (C) 2006-2008 Midnight Coders, Inc.
    *
    * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ********************************************************************/
    <xsl:call-template name="codegen.file.comment" />
  </xsl:template>
</xsl:stylesheet> 
