<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="codegen.server.csharp.data.mysql.save">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)"   />
    <xsl:variable name="table" select="@name"   />
    <xsl:variable name="functionParam" select="codegen:FunctionParameter($class-name)" />
    [TransactionRequired]
    public override <xsl:value-of select="$class-name" /> save( <xsl:value-of select="$class-name" /><xsl:text> </xsl:text><xsl:value-of select="$functionParam" /> )
    {
      if(exists(<xsl:value-of select="$functionParam" />))
        return update(<xsl:value-of select="$functionParam" />);
        return create(<xsl:value-of select="$functionParam" />);
    }

  </xsl:template>
</xsl:stylesheet>