<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="codegen.xslt"/>

  
  <xsl:template name="codegen.invoke.method.name">
    <xsl:value-of select="@name"/>
  </xsl:template>
  
  <xsl:template name="codegen.invoke.method">
    <xsl:for-each select="arg[complex-value]">
      <xsl:variable name="var" select="@name" />
      var <xsl:value-of select="$var"/> = new <xsl:value-of select="@name" />();

      <xsl:for-each select="complex-value/field">
        <xsl:call-template name="codegen.create.complex.type">
          <xsl:with-param name="var" select="$var" />
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>

    <xsl:for-each select="arg[array-value]">
      <xsl:variable name="var" select="@name" />
      var <xsl:value-of select="$var"/> = new Array();

      <xsl:for-each select="array-value/item">
        <xsl:call-template name="codegen.fill.array">
          <xsl:with-param name="var" select="$var" />
        </xsl:call-template>
      </xsl:for-each>
    </xsl:for-each>


    <xsl:call-template name="codegen.invoke.method.name" />(<xsl:for-each select="arg">
      <xsl:if test="position() != 1">,</xsl:if>
      <xsl:choose>
        <xsl:when test="complex-value">
          <xsl:value-of select="@name"/>
        </xsl:when>
        <xsl:when test="@type = 'String'">'<xsl:value-of select="@value"/>'
        </xsl:when>
        <xsl:when test="@type = 'Array'">
          <xsl:choose>
            <xsl:when test="array-value">
              <xsl:value-of select="@name"/>
            </xsl:when>
            <xsl:otherwise>null</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="value"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>);
  </xsl:template>

  <xsl:template name="codegen.fill.array">
    <xsl:param name="var" />

    <xsl:choose>
      <xsl:when test="array-value">
        <xsl:variable name="new-array-name" select="concat($var,'_',@type,'_ArrayItem')" />
        var <xsl:value-of select="$new-array-name"/> = new Array();
        <xsl:for-each select="array-value/item">
          <xsl:call-template name="codegen.fill.array">
            <xsl:with-param name="var" select="$new-array-name" />
          </xsl:call-template>
        </xsl:for-each>
        <xsl:value-of select="$var"/>.push(<xsl:value-of select="$new-array-name"/>);
      </xsl:when>
      <xsl:when test="complex-value">
        <xsl:variable name="new-object-name" select="concat($var,'_',@type,'_ArrayItem')" />
        var <xsl:value-of select="$new-object-name"/> = new <xsl:value-of select="@type"/>();

        <xsl:for-each select="complex-value/field">
          <xsl:call-template name="codegen.create.complex.type">
            <xsl:with-param name="var" select="$var" />
          </xsl:call-template>
        </xsl:for-each>

        <xsl:value-of select="$var"/>.push(<xsl:value-of select="$new-object-name"/>);
      </xsl:when>
      <xsl:when test="value">
        <xsl:choose>
          <xsl:when test="@type = 'String'">
            <xsl:value-of select="$var"/>.push('<xsl:value-of select="value"/>');
          </xsl:when>
          <xsl:when test="string-length(value) = 0">
            <xsl:value-of select="$var"/>.push(null);
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$var"/>.push(<xsl:value-of select="value"/>);
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="codegen.create.complex.type">
    <xsl:param name="var" />
    <xsl:variable name="field-name" select="concat($var,'.',@name)" />

    <xsl:value-of select="$field-name"/> = <xsl:choose>
      <xsl:when test="complex-value">new <xsl:value-of select="@name" />();
        <xsl:for-each select="complex-value/field">
          <xsl:call-template name="codegen.create.complex.type">
            <xsl:with-param name="var" select="$field-name" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@type = 'String'">'<xsl:value-of select="value"/>';
      </xsl:when>
      <xsl:when test="@type = 'Array'">new Array();
        <xsl:choose>
          <xsl:when test="array-value">
            <xsl:for-each select="array-value/item">
              <xsl:call-template name="codegen.fill.array">
                <xsl:with-param name="var" select="$field-name" />
              </xsl:call-template>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@type = 'Date'">new Date("<xsl:value-of select='value'/>");
      </xsl:when>
      <xsl:when test="@type = 'Number' or @type = 'int'">
        <xsl:choose>
          <xsl:when test="value">
            <xsl:value-of select="value"/>
          </xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>;
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="value"/>;
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>