<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
                  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
                  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../import/codegen.import.keys.xslt"/>

  <xsl:template name="codegen.server.csharp.domain.enviroment" />
  
  <xsl:template name="codegen.server.csharp.domain">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)"   />
    <xsl:variable name="table" select="@name"   />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name"   />
    <xsl:value-of select="codegen:Progress(concat('Generating class ', $class-name))" />
    
    public partial class <xsl:value-of select="$class-name"/>: DomainObject
    {
    <xsl:for-each select="xs:complexType/xs:attribute[not(concat('@',@name) = key('fk',$class-name)/@xpath)]">
      protected <xsl:value-of select="codegen:CSharpDataType(@type)"/><xsl:if test="@use = 'optional' and codegen:IsNullable(@type)">?</xsl:if><xsl:text> </xsl:text>_<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />;
    </xsl:for-each>

    <xsl:for-each select="xs:keyref">
      <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
      <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table,@name,1))" />

      // parent tables
      protected <xsl:value-of select="codegen:getClassName($parent-table)"/><xsl:text> </xsl:text><xsl:value-of select="$parent-property" />
      <xsl:if test="xs:field[substring(@xpath,2) = ../../xs:complexType/xs:attribute[@use='required']/@name]">
        = new <xsl:value-of select="codegen:getClassName($parent-table)"/>()
      </xsl:if>;
    </xsl:for-each>

    public <xsl:value-of select="$class-name"/>(){}

    public <xsl:value-of select="$class-name"/>(
    <xsl:for-each select="xs:complexType/xs:attribute">
      <xsl:value-of select="codegen:CSharpDataType(@type)" />
      <xsl:text> 
            </xsl:text>
      <xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />
      <xsl:if test="position() != last()">,</xsl:if>
    </xsl:for-each>
    )
    {
    <xsl:for-each select="xs:complexType/xs:attribute">
      this.<xsl:value-of select="codegen:getPropertyName($table,@name)" /> = <xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />;
    </xsl:for-each>
    }

    public override bool contains(Hashtable fields)
    {
      int matchCount = 0;
      <xsl:for-each select="xs:complexType/xs:attribute">
        if(fields.ContainsKey("<xsl:value-of select="codegen:getPropertyName($table,@name)"/>"))
        {
          <xsl:choose>
            <xsl:when test="@type = 'xs:anyURI'">
              if(! (new Guid(fields["<xsl:value-of select="codegen:getPropertyName($table,@name)"/>"].ToString()).Equals( 
                this.<xsl:value-of select="codegen:getPropertyName($table,@name)"/> )))
            </xsl:when>
            <xsl:otherwise>
              if(!fields["<xsl:value-of select="codegen:getPropertyName($table,@name)"/>"].Equals(this.<xsl:value-of select="codegen:getPropertyName($table,@name)"/>))
            </xsl:otherwise>
          </xsl:choose>
            return false;
          else if(++matchCount == fields.Count)
            return true;
        }
      </xsl:for-each>
    
      return matchCount == fields.Count;
    }

    public override String  getUri()
    {

    String uri = "<xsl:value-of select="../../../@name"/>.<xsl:value-of select="@name"/>"
    <xsl:for-each select="xs:key/xs:field">
      + "." + <xsl:value-of select="codegen:getPropertyName($table,substring(@xpath,2))" />.ToString()
    </xsl:for-each>;
    
    return uri;
    }

    <xsl:for-each select="xs:complexType/xs:attribute">
      <xsl:variable name="attribute-name" select="@name" />
      
      <xsl:variable name="optional" select="boolean(@use = 'optional')" />
      <xsl:variable name="support-null" select="codegen:IsNullable(@type)" />

      public <xsl:value-of select="codegen:CSharpDataType(@type)" /><xsl:if test="@use = 'optional' and $support-null">?</xsl:if><xsl:text> </xsl:text><xsl:value-of select="codegen:getPropertyName($table,@name)" />
      {
        <xsl:choose>
          <xsl:when test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
            get { return _<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />;}
            set 
            { 
                _<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" /> = value;
            }
          </xsl:when>
          <xsl:otherwise>
            get
            {
            <xsl:for-each select="key('tableById',$id)/xs:keyref">
              <xsl:for-each select="xs:field">
                <xsl:if test="@xpath = concat('@',$attribute-name)">
                  <xsl:variable name="pk-field-position" select="position()" />
                  <xsl:variable name="parent-table-name" select="key('table', ../@refer)/@name" />
                  <xsl:variable name="parent-pk-field-name" select="key('table',../@refer)/xs:key/xs:field[$pk-field-position]/@xpath" />
                  <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table-name,../@name,1))" />
                  if(<xsl:value-of select="$parent-property"/> != null)
                    return <xsl:value-of select="$parent-property"/>.<xsl:value-of select="codegen:getPropertyName($parent-table-name, substring($parent-pk-field-name,2) ) "/>;

                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>

            <xsl:choose>
              <xsl:when test="$optional">
                <xsl:choose>
                  <xsl:when test="@type = 'xs:anyURI'">
                    return Guid.Empty;
                  </xsl:when>
                  <xsl:otherwise>
                    return null;
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>throw new NullReferenceException("Parent instance not initialized ");</xsl:otherwise>
            </xsl:choose>
            }
            set
            {
            <xsl:for-each select="key('tableById',$id)/xs:keyref">
              <xsl:for-each select="xs:field">
                <xsl:if test="@xpath = concat('@',$attribute-name)">
                  <xsl:variable name="pk-field-position" select="position()" />
                  <xsl:variable name="parent-table-name" select="key('table', ../@refer)/@name" />
                  <xsl:variable name="parent-pk-field-name" select="key('table',../@refer)/xs:key/xs:field[$pk-field-position]/@xpath" />
                  <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table-name,../@name,1))" />

                  <xsl:choose>
                    <xsl:when test="$optional and $support-null">
                      if(!value.HasValue)
                        <xsl:value-of select="$parent-property"/> = null;
                      else
                      {
                      if(<xsl:value-of select="$parent-property"/> == null)
                        <xsl:value-of select="$parent-property"/> = new <xsl:value-of select="codegen:getClassName($parent-table-name)"/>();

                        <xsl:value-of select="$parent-property"/>.<xsl:value-of select="codegen:getPropertyName($parent-table-name,substring($parent-pk-field-name,2)) "/> = value.Value;
                      }
                    </xsl:when>
                    <xsl:otherwise>
                      if(<xsl:value-of select="codegen:getClassName($parent-property)"/> == null)
                        <xsl:value-of select="codegen:getClassName($parent-property)"/> = new <xsl:value-of select="codegen:getClassName($parent-table-name)"/>();

                      <xsl:value-of select="codegen:getClassName($parent-property)"/>.<xsl:value-of select="codegen:getPropertyName($parent-table-name, substring($parent-pk-field-name,2)) "/> = value;
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>                
              </xsl:for-each>
            </xsl:for-each>
            }
          </xsl:otherwise>
        </xsl:choose>
      }
    </xsl:for-each>

    <xsl:for-each select="xs:keyref">
      <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
      <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table,@name,1))" />

      public <xsl:value-of select="codegen:getClassName($parent-table)"/><xsl:text> </xsl:text><xsl:value-of select="codegen:getParentProperty($table, $parent-table, @name,0)" />
      {
      get { return <xsl:value-of select="$parent-property" />;}
      set { <xsl:value-of select="$parent-property" /> = value; }
      }
      
    </xsl:for-each>

    public override IDataMapper createDataMapper(ITransactionContext transactionContext)
    {
        return new <xsl:value-of select="$class-name"/>DataMapper(
          (<xsl:value-of select="codegen:getClassName(../../../@name)" />Db)transactionContext);
    }

    public override DomainObject extractSingleObject()
    {
    <xsl:value-of select="$class-name"/><xsl:text> </xsl:text><xsl:value-of select="codegen:getFunctionParameter($class-name)"/> = new <xsl:value-of select="$class-name"/>();
      
      <xsl:for-each select="xs:complexType/xs:attribute">
        <xsl:value-of select="codegen:getFunctionParameter($class-name)"/>.<xsl:value-of select="codegen:getPropertyName($table,@name)" /> = this.<xsl:value-of select="codegen:getPropertyName($table,@name)" />;
      </xsl:for-each>
        
       <xsl:value-of select="codegen:getFunctionParameter($class-name)"/>.ActiveRecordUID = this.ActiveRecordUID;
    return <xsl:value-of select="codegen:getFunctionParameter($class-name)"/>;
    }

    <xsl:for-each select="key('dependent',current()/xs:key/@name)">
      <xsl:variable name="child-table-pk" select="xs:key/@name" />
      <xsl:for-each select="xs:keyref[@refer = $pk]">
        <xsl:variable name="fk" select="@name" />
        <xsl:for-each select="key('table',$child-table-pk)">
        <xsl:variable name="child-property" select="concat('_',codegen:getChildProperty($table,@name,$fk, 1))" />
          <xsl:choose>
            <xsl:when test="count(xs:key/xs:field[@xpath = key('fkByName',$fk)/@xpath]) = count(xs:key/xs:field)">
              // one to one relation
              <xsl:value-of select="codegen:getClassName(@name)"/><xsl:text> </xsl:text><xsl:value-of select="$child-property" />;
              public <xsl:value-of select="codegen:getClassName(@name)"/><xsl:text> </xsl:text><xsl:value-of select="codegen:getChildProperty($table, @name, $fk, 0)" />
              {
              get { return <xsl:value-of select="$child-property" />;}
              set { <xsl:value-of select="$child-property" /> = value; }
              }
            </xsl:when>
            <xsl:otherwise>
              // one to many relation
              private List&lt;<xsl:value-of select="codegen:getClassName(@name)"/>&gt; <xsl:value-of select="$child-property" />;

              public List&lt;<xsl:value-of select="codegen:getClassName(@name)"/>&gt;<xsl:text> </xsl:text><xsl:value-of select="codegen:getChildProperty($table,@name,$fk, 1)" />
              {
              get { return <xsl:value-of select="$child-property" />;}
              set { <xsl:value-of select="$child-property" /> = value; }
              }


              public <xsl:value-of select="codegen:getClassName(@name)"/><xsl:text> </xsl:text>add<xsl:value-of select="codegen:getChildProperty($table,@name,$fk, 0)" />Item(
              <xsl:value-of select="codegen:getClassName(@name)"/><xsl:text> </xsl:text><xsl:value-of select="codegen:getFunctionParameter( codegen:getClassName(@name) )"/>)
              {
              <xsl:value-of select="codegen:getFunctionParameter( codegen:getClassName(@name) )"/>.<xsl:value-of select="codegen:getParentProperty(@name, $table, $fk, 0)"/> = this;

              <xsl:value-of select="$child-property" />.Add(<xsl:value-of select="codegen:getFunctionParameter( codegen:getClassName(@name) )"/>);

              return <xsl:value-of select="codegen:getFunctionParameter( codegen:getClassName(@name) )"/>;
              }

            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
    }
  </xsl:template>
</xsl:stylesheet>