<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../../import/codegen.import.keys.xslt"/>


  <xsl:template name="codegen.server.csharp.data.mysql.findAll">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)"   />
    <xsl:variable name="table" select="@name"   />
    <xsl:variable name="functionParam" select="codegen:FunctionParameter(@name)" />
    <xsl:variable name="identity" select="boolean(xs:complexType/xs:attribute[@default='identity'])" />

    private const String SqlSelectAll = @"Select
    <xsl:for-each select="xs:complexType/xs:attribute">
       <xsl:value-of select="@name" /> <xsl:if test="position() != last()">,</xsl:if> 
    </xsl:for-each> 
    From `<xsl:value-of select="$table" />` ";

    public QueryResult<xsl:text> </xsl:text>findAll(Hashtable options)
    {
    QueryOptions queryOptions = new QueryOptions(options);
    String queryId = Guid.NewGuid().ToString();

    if(queryOptions.IsPaged || queryOptions.IsMonitored)
    registerCollection(SqlSelectAll,queryId,queryOptions);

    if(queryOptions.IsPaged)
    return getQueryPage(queryId,1);

    using (DatabaseConnectionMonitor monitor = new DatabaseConnectionMonitor(Database))
    {
    using(MySqlCommand sqlCommand = Database.CreateCommand(SqlSelectAll))
    {
    return new QueryResult(queryId, queryOptions.IsMonitored, fill(sqlCommand,queryOptions.Offset,queryOptions.Limit));

    }

    }
    }
  </xsl:template>
</xsl:stylesheet>