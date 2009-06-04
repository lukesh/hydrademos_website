<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
                  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:import href="codegen.server.csharp.data.mssql.create.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.update.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.remove.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.findAll.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.load.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.save.xslt"/>
  <xsl:import href="codegen.server.csharp.data.mssql.findByPrimaryKey.xslt"/>
  
  <xsl:template name="codegen.server.csharp.data.mssql.enviroment">
    <xsl:if test="codegen:singleCall('codegen.server.csharp.data.mssql.enviroment')">
      using System.Data.SqlClient;
    </xsl:if>
  </xsl:template>

  <xsl:template name="codegen.server.csharp.data.mssql.database">
    public partial class <xsl:value-of select="codegen:getClassName(@name)" />Db:TDatabase&lt;SqlConnection,SqlTransaction,SqlCommand&gt;
    {
      public <xsl:value-of select="codegen:getClassName(@name)" />Db()
      {
        InitConnectionString("<xsl:value-of select="@name"/>");
      }

    <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
        <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
        <xsl:variable name="functionParam" select="codegen:FunctionParameter($class-name)" />

        public <xsl:value-of select="$class-name"/> create(<xsl:value-of select="$class-name"/><xsl:text> </xsl:text><xsl:value-of select="$functionParam"/>)
        {
          <xsl:value-of select="$class-name"/>DataMapper dataMapper = new <xsl:value-of select="$class-name"/>DataMapper(this);
          
          return dataMapper.create(<xsl:value-of select="$functionParam"/>);
        }

        public <xsl:value-of select="$class-name"/> update(<xsl:value-of select="$class-name"/><xsl:text> </xsl:text><xsl:value-of select="$functionParam"/>)
        {
          <xsl:value-of select="$class-name"/>DataMapper dataMapper = new <xsl:value-of select="$class-name"/>DataMapper(this);

          return dataMapper.update(<xsl:value-of select="$functionParam"/>);
        }

        public <xsl:value-of select="$class-name"/> remove(<xsl:value-of select="$class-name"/><xsl:text> </xsl:text><xsl:value-of select="$functionParam"/>, bool cascade)
        {
          <xsl:value-of select="$class-name"/>DataMapper dataMapper = new <xsl:value-of select="$class-name"/>DataMapper(this);

          return dataMapper.remove(<xsl:value-of select="$functionParam"/>, cascade);
        }
    </xsl:for-each>

      <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='storedprocedure']">
        public DataSet <xsl:value-of select="codegen:getStoredProcedureName(@name)"/>(
        <xsl:for-each select="xs:complexType/xs:attribute">
          <xsl:value-of select="codegen:CSharpDataType(@type)" />
          <xsl:text> 
            </xsl:text>
          <xsl:value-of select="codegen:getFunctionParameter(@name)" />
          <xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>)
        {
            DataSet dataSet = new DataSet();

            using (DatabaseConnectionMonitor databaseConnectionMonitor = new DatabaseConnectionMonitor(this))
            {
                using (SqlCommand sqlCommand = new SqlCommand("<xsl:value-of select="@name" />", Connection))
                {
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    
                    <xsl:for-each select="xs:complexType/xs:attribute">
                      sqlCommand.Parameters.AddWithValue("@<xsl:value-of select="@name"/>", 
                        <xsl:value-of select="codegen:getFunctionParameter(@name)" />);
                    </xsl:for-each>
        
                    SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                    
                    sqlDataAdapter.Fill(dataSet);
                }
            }

            return dataSet;
        }
      </xsl:for-each>
    }
  </xsl:template>
  
  <xsl:template name="codegen.server.csharp.data.mssql">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)"   />
    <xsl:variable name="table" select="@name"   />
    <xsl:variable name="functionParam" select="codegen:FunctionParameter(@name)" />
    <xsl:variable name="identity" select="boolean(xs:complexType/xs:attribute[@default='identity'])" />
    <xsl:variable name="db-class" select="codegen:getClassName(concat(../../../@name,'Db'))" />

    public abstract class _<xsl:value-of select="$class-name"/>DataMapper:TDataMapper&lt;<xsl:value-of select="$class-name"/>,SqlConnection,<xsl:value-of select="$db-class"/>, Weborb.Data.Management.MSSql.CommandBuilder, SqlTransaction, SqlCommand&gt;
    {
      public _<xsl:value-of select="$class-name"/>DataMapper(){}
      public _<xsl:value-of select="$class-name"/>DataMapper(<xsl:value-of select="$db-class"/> database):
      base(database){}
        public override String TableName
        {
          get
          {
            return "[<xsl:value-of select="@wdm:Schema" />].[<xsl:value-of select="$table"/>]";
          }
        }
        
        public override String getSafeName(String name)
        {
          return String.Format("[{0}]",name);
        }

        public override Hashtable getRelation(string tableName)
        {
          throw new Exception("Not yet implemented");
        }

        <xsl:call-template name="codegen.server.csharp.data.mssql.create" />
        <xsl:call-template name="codegen.server.csharp.data.mssql.findByPrimaryKey" />
        <xsl:call-template name="codegen.server.csharp.data.mssql.load" />
        <xsl:call-template name="codegen.server.csharp.data.mssql.remove" />
        <xsl:call-template name="codegen.server.csharp.data.mssql.save" />
        <xsl:call-template name="codegen.server.csharp.data.mssql.update" />
    }
    
  </xsl:template>  
</xsl:stylesheet>