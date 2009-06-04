<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>

  <xsl:template name="codegen.code">
    load("netservices.asc");

    NetServices.setDefaultGatewayUrl("<xsl:value-of select='@url'/>");
    var netServices = NetServices.createGatewayConnection();

    var service = netServices.getService("<xsl:value-of select='@name'/>", new <xsl:value-of select='@name'/>());

    <xsl:for-each select='method'>
      service.<xsl:value-of select='@name'/>();
    </xsl:for-each>
    
    function <xsl:value-of select='@name'/>()
    {

    }

    <xsl:for-each select='method'>
      <xsl:value-of select='../@name'/>.prototype.<xsl:value-of select='@name'/>_Result = function(result);
    </xsl:for-each>
   
  </xsl:template>

</xsl:stylesheet>
