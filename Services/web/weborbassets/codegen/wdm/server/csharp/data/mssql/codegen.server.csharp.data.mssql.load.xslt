<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="codegen.server.csharp.data.mssql.load">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)"   />
    <xsl:variable name="functionParam" select="codegen:FunctionParameter($class-name)" />
    <xsl:variable name="table" select="@name" />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="schema" select="@wdm:Schema" />
    
    protected override <xsl:value-of select="$class-name" /> doLoad(IDataReader dataReader)
    {
    <xsl:value-of select="$class-name" /><xsl:text> </xsl:text><xsl:value-of select="$functionParam" /> = new<xsl:text> </xsl:text><xsl:value-of select="$class-name" />();

    <xsl:for-each select="xs:complexType/xs:attribute">
      <xsl:variable name="property" select="codegen:getProperty($table,@name)" />
      <xsl:choose>
        <xsl:when test="@use = 'optional'">
          if(!dataReader.IsDBNull(<xsl:value-of select="position()-1" />))        
          <xsl:choose>
            <xsl:when test="@type = 'xs:base64Binary' or @type = 'xs:timestamp'">
               <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = getBytes( dataReader, <xsl:value-of select="position()-1" />);
            </xsl:when>    
            <xsl:otherwise>
              <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = (<xsl:value-of select="codegen:CSharpDataType(@type)" />) dataReader.GetValue(<xsl:value-of select="position()-1" />);
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="@type = 'xs:base64Binary' or @type = 'xs:timestamp'">
               <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = getBytes( dataReader, <xsl:value-of select="position()-1" />);
            </xsl:when>    
            <xsl:otherwise>
               <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = (<xsl:value-of select="codegen:CSharpDataType(@type)" />) dataReader.GetValue(<xsl:value-of select="position()-1" />);
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    return registerRecord(<xsl:value-of select="$functionParam" />);
    }


    protected override <xsl:value-of select="$class-name" /> doLoad(Hashtable hashtable)
    {
      <xsl:value-of select="$class-name" /><xsl:text> </xsl:text><xsl:value-of select="$functionParam" /> = new<xsl:text> </xsl:text><xsl:value-of select="$class-name" />();

      <xsl:for-each select="xs:complexType/xs:attribute">
      <xsl:variable name="property" select="codegen:getProperty($table,@name)" />
        
        if(hashtable.ContainsKey("<xsl:value-of select="@name"/>"))
        <xsl:choose>
          <xsl:when test="@type='xs:base64Binary' or @type = 'xs:timestamp'">
            <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = hashtable["<xsl:value-of select="$property"/>"] as <xsl:value-of select="codegen:CSharpDataType(@type)" />;
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$functionParam" />.<xsl:value-of select="$property"/> = ( <xsl:value-of select="codegen:CSharpDataType(@type)" />)hashtable["<xsl:value-of select="$property"/>"];
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      return <xsl:value-of select="$functionParam" />;
    }


    protected override List&lt;<xsl:value-of select="$class-name" />&gt; fill(SqlCommand sqlCommand, int offset, int limit)
    {
         List&lt;<xsl:value-of select="$class-name" />&gt; resultList = new List&lt;<xsl:value-of select="$class-name" />&gt;();
    
         using(SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand))
         {
            DataTable dataTable = new DataTable();
            
            sqlDataAdapter.Fill(offset,limit,dataTable);
            
            foreach(DataRow dataRow in dataTable.Rows)
            {
              <xsl:value-of select="$class-name" /> item = new <xsl:value-of select="$class-name" />();
              
              <xsl:for-each select="xs:complexType/xs:attribute">
              <xsl:variable name="property" select="codegen:getProperty($table,@name)" />
                <xsl:if test="@use = 'optional'">
                  if(!dataRow.IsNull("<xsl:value-of select="@name"/>"))
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="@type = 'xs:base64Binary' or @type = 'xs:timestamp'">
                    item.<xsl:value-of select="$property"/> = dataRow["<xsl:value-of select="@name"/>"] as <xsl:value-of select="codegen:CSharpDataType(@type)" />;
                  </xsl:when>
                  <xsl:otherwise>
                    item.<xsl:value-of select="$property"/> = ( <xsl:value-of select="codegen:CSharpDataType(@type)" />)dataRow["<xsl:value-of select="@name"/>"] ;
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
    
              registerRecord(item);

              resultList.Add(item);
            }
        }

      return resultList;
    }

    <xsl:for-each select="xs:keyref">
      <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
      <xsl:variable name="parent-property" select="codegen:getParentProperty($table,$parent-table,@name,0)" />
      <xsl:variable name="sql-name" select="concat('SqlFindBy',$parent-property)" />
      private const String <xsl:value-of select="$sql-name"/> = @"select * from [<xsl:value-of select="$schema"/>].[<xsl:value-of select="$table" />]
      where
      <xsl:for-each select="xs:field">
        <xsl:if test="position() != 1">
          and
        </xsl:if>
        [<xsl:value-of select="substring(@xpath,2)"/>] = @<xsl:value-of select="substring(@xpath,2)"/>
      </xsl:for-each>";

      //Note: this function can be called only from server side
      internal List&lt;<xsl:value-of select="$class-name" />&gt; findBy<xsl:value-of select="$parent-property"/>(<xsl:value-of select="codegen:getClassName($parent-table)"/> domainObject, QueryOptions queryOptions)
      {
        List&lt;<xsl:value-of select="$class-name" />&gt; result = null;
        
        using(SqlCommand sqlCommand = Database.CreateCommand(<xsl:value-of select="$sql-name"/>))
        {
          <xsl:for-each select="xs:field">
            <xsl:variable name="pk-field-position" select="position()" />
            <xsl:variable name="parent-pk-field-name" select="key('table',../@refer)/xs:key/xs:field[$pk-field-position]/@xpath" />

            sqlCommand.Parameters.AddWithValue("@<xsl:value-of select="substring(@xpath,2)"/>",
            domainObject.<xsl:value-of select="codegen:getPropertyName($parent-table,substring($parent-pk-field-name,2))" />);
          </xsl:for-each>

          result = fill(sqlCommand,0,0);
        }
        
        foreach(<xsl:value-of select="$class-name" /> item in result)
          item.<xsl:value-of select="$parent-property"/> = domainObject;

         <xsl:if test="key('dependent',$pk)">
           loadRelations(result,queryOptions);
         </xsl:if>

        return result;
      }

    </xsl:for-each>

    <xsl:if test="key('dependent',current()/xs:key/@name)">
      protected override void loadRelations(<xsl:value-of select="$class-name" /> domainObject, QueryOptions queryOptions)
      {
      foreach(String relationName in queryOptions.GetRelations(this))
      {
        <xsl:for-each select="key('dependent',current()/xs:key/@name)">
          <xsl:variable name="child-table" select="@name" />
          <xsl:variable name="child-table-pk" select="xs:key/@name" />
          <xsl:for-each select="xs:keyref[@refer = $pk]">
            <xsl:variable name="fk" select="@name" />
            <xsl:for-each select="key('table',$child-table-pk)">
              <xsl:choose>
                <xsl:when test="count(xs:key/xs:field[@xpath = key('fkByName',$fk)/@xpath]) = count(xs:key/xs:field)">
                </xsl:when>
                <xsl:otherwise>
                  <xsl:variable name="hidden-property" select="codegen:getChildProperty($table,@name,$fk,1)" />
                  <xsl:variable name="relation-property" select="codegen:getChildProperty($table,@name,$fk,0)" />
                  <xsl:variable name="reverse-property" select="codegen:getParentProperty($child-table,$table,$fk,0)" />

                  if(relationName == "<xsl:value-of select="$relation-property" />")
                  {
                    <xsl:value-of select="codegen:getClassName($child-table)" />DataMapper dataMapper = new <xsl:value-of select="codegen:getClassName($child-table)" />DataMapper(Database);

                    domainObject.<xsl:value-of select="$hidden-property" /> = dataMapper.findBy<xsl:value-of select="$reverse-property"/>(domainObject,queryOptions);

                  }
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
           </xsl:for-each>
        </xsl:for-each>
        }
      }
    </xsl:if>


  </xsl:template>

  
  </xsl:stylesheet>