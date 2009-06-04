<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  
  <xsl:template name="codegen.client.domain.codegen">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />

    <file name="{concat('_',$class-name)}.as" override="true" >
      package <xsl:value-of select="codegen:getClientNamespace()" />.Codegen
      {
      import weborb.data.*;
      import <xsl:value-of select="codegen:getClientNamespace()" />.*;
      import mx.collections.ArrayCollection;
      import flash.utils.ByteArray;

      [Bindable]
      public dynamic class _<xsl:value-of select="$class-name"/> extends ActiveRecord
      {

        public function get ActiveRecordUID():String
        {
          return _activeRecordId;
        }

        public function set ActiveRecordUID(value:String):void
        {
          _activeRecordId = value;
        }
      
      private var _uri:String = null;

      <xsl:for-each select="xs:complexType/xs:attribute[not(concat('@',@name) = key('fk',$class-name)/@xpath)]">
        protected var _<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />: <xsl:value-of select="codegen:getASDataType(@type)" />
        <xsl:if test="codegen:getASDataType(@type) = 'Number'"> = 0</xsl:if>;
      </xsl:for-each>

      <xsl:for-each select="xs:keyref">
        // parent tables
        internal var _<xsl:value-of select="codegen:getParentProperty($table, key('table',@refer)/@name, @name,1)" />:<xsl:text> </xsl:text><xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)"/>
        <xsl:if test="xs:field[substring(@xpath,2) = ../../xs:complexType/xs:attribute[@use='required']/@name]">
            = new <xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)"/>()
        </xsl:if>;
      </xsl:for-each>



      <xsl:for-each select="xs:complexType/xs:attribute">
        <xsl:variable name="attribute-name" select="@name" />
        <xsl:variable name="property" select="codegen:getPropertyName($table,@name)" />
        
        <xsl:choose>
          <xsl:when test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
            public function get <xsl:text> </xsl:text><xsl:value-of select="$property" />(): <xsl:value-of select="codegen:getASDataType(@type)" />
            {
              return _<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" />;
            }

            public function set <xsl:text> </xsl:text><xsl:value-of select="$property" />(value:<xsl:value-of select="codegen:getASDataType(@type)" />):void
            {
            <xsl:if test="../../xs:key/xs:field[@xpath = concat('@',current()/@name)]">
              _isPrimaryKeyAffected = true;
              _uri = null;

              if(IsLoaded || IsLoading)
              {
                trace("Critical error: attempt to modify primary key in initialized object " + getURI());
                return;
              }
            </xsl:if>
            _<xsl:value-of select="codegen:getFunctionParameter(codegen:getPropertyName($table,@name))" /> = value;
            }
          </xsl:when>
          <xsl:otherwise>
            public function get <xsl:text> </xsl:text><xsl:value-of select="$property" />(): <xsl:value-of select="codegen:getASDataType(@type)" />
            {
            <xsl:for-each select="key('tableById',$id)/xs:keyref">
              <xsl:for-each select="xs:field">
                <xsl:if test="@xpath = concat('@',$attribute-name)">
                  <xsl:variable name="pk-field-position" select="position()" />
                  <xsl:variable name="parent-table-name" select="key('table', ../@refer)/@name" />
                  <xsl:variable name="parent-class-name" select="codegen:getClassName($parent-table-name)" />
                  <xsl:variable name="parent-pk-field-name" select="key('table',../@refer)/xs:key/xs:field[$pk-field-position]/@xpath" />
                  <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table-name,../@name,1))" />

                  if(<xsl:value-of select="$parent-property"/> != null)
                  return <xsl:value-of select="$parent-property"/>.<xsl:value-of select="codegen:getPropertyName($parent-table-name, substring($parent-pk-field-name,2)) "/>;

                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
            
            
            return undefined;
            }
            protected function set<xsl:text> </xsl:text><xsl:value-of select="$property" />(value:<xsl:value-of select="codegen:getASDataType(@type)" />):void
            {

            <xsl:for-each select="key('tableByName',$table)/xs:keyref">
              <xsl:for-each select="xs:field">
                <xsl:if test="@xpath = concat('@',$attribute-name)">
                  <xsl:variable name="pk-field-position" select="position()" />
                  <xsl:variable name="parent-table-name" select="key('table', ../@refer)/@name" />
                  <xsl:variable name="parent-class-name" select="codegen:getClassName($parent-table-name)" />                  
                  <xsl:variable name="parent-pk-field-name" select="key('table',../@refer)/xs:key/xs:field[$pk-field-position]/@xpath" />
                  <xsl:variable name="parent-property" select="concat('_', codegen:getParentProperty($table,$parent-table-name,../@name,1))" />

                  if(<xsl:value-of select="$parent-property"/> == null)
                      <xsl:value-of select="$parent-property"/> = new <xsl:value-of select="$parent-class-name"/>();

                  <xsl:value-of select="$parent-property"/>.<xsl:value-of select="codegen:getPropertyName($parent-table-name,substring($parent-pk-field-name,2))"/> = value;
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>

            <xsl:if test="../../xs:key/xs:field[@xpath = concat('@',current()/@name)]">
              _isPrimaryKeyAffected = true;
              _uri = null;
            </xsl:if>
            
            }
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>

      <xsl:for-each select="xs:keyref">
        <xsl:variable name="key" select="@name" />
        <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
        <xsl:variable name="parent-class" select="codegen:getClassName($parent-table)" />
        <xsl:variable name="var-name" select="concat('_',codegen:getParentProperty($table,$parent-table,$key,1))" />
        [Bindable(event="loaded")]
        public function get <xsl:value-of select="codegen:getParentProperty($table, $parent-table, $key,0)" />():<xsl:value-of select="$parent-class"/>
        {
        if(IsLazyLoadingEnabled <![CDATA[ && ]]>
        <xsl:if test="not(xs:field[substring(@xpath,2) = ../../xs:complexType/xs:attribute[@use='required']/@name])">
          <xsl:value-of select="$var-name" /> <![CDATA[ && ]]>
        </xsl:if>
        !(<xsl:value-of select="$var-name" />.IsLoaded || <xsl:value-of select="$var-name" />.IsLoading))
        {
         var oldValue:ActiveRecord = <xsl:value-of select="$var-name" />;
         
          <xsl:value-of select="$var-name" /> = DataMapperRegistry.Instance.<xsl:value-of select="$parent-class"/>.load(<xsl:value-of select="$var-name" />);
          
          if(oldValue != <xsl:value-of select="$var-name" />)
            onParentChanged(oldValue, <xsl:value-of select="$var-name" />);
        }

        return <xsl:value-of select="$var-name" />;
        }
        public function set <xsl:value-of select="codegen:getParentProperty($table, $parent-table, $key,0)" />(value:<xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)"/>):void
        {
          if( value != null )
          {
          	var oldValue:ActiveRecord = <xsl:value-of select="$var-name" />;
          	
            <xsl:value-of select="$var-name" /> = <xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)" />(IdentityMap.global.register( value ));

            if(oldValue != <xsl:value-of select="$var-name" />)
              onParentChanged(oldValue, <xsl:value-of select="$var-name" />);
          }
          else
            <xsl:value-of select="$var-name" /> = null;
            
          <xsl:if test="xs:field[@xpath = key('pkByName',$pk)/@xpath]">
            _isPrimaryKeyAffected = true;
            _uri = null;
          </xsl:if>
        }
      </xsl:for-each>

      <xsl:for-each select="key('dependent',current()/xs:key/@name)">
        <xsl:variable name="child-table" select="@name" />
        <xsl:variable name="child-table-pk" select="xs:key/@name" />
        
        <xsl:for-each select="xs:keyref[@refer = $pk]">
          <xsl:variable name="fk" select="@name" />
          <xsl:for-each select="key('table',$child-table-pk)">
            <xsl:choose>
              <xsl:when test="count(xs:key/xs:field[@xpath = key('fkByName',$fk)/@xpath]) = count(xs:key/xs:field)">
                    
                <xsl:variable name="var-name" select="concat('_',codegen:getChildProperty($table,$child-table,$fk,1))" />
                

                // one to one relation
                internal var <xsl:value-of select="$var-name" />:<xsl:value-of select="codegen:getClassName(@name)"/>;
                [Bindable(event="loaded")]
                public function get <xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,0)" />():<xsl:value-of select="codegen:getClassName(@name)"/>
                {

                if(IsLazyLoadingEnabled <![CDATA[&&]]> <xsl:value-of select="$var-name" /> == null )
                {

                <xsl:value-of select="$var-name" /> = DataMapperRegistry.Instance.<xsl:value-of select="codegen:getClassName(@name)" />.findByPrimaryKey(
                <xsl:for-each select="key('pkByName',$pk)">
                  <xsl:if test="position() != 1">,</xsl:if>
                  <xsl:value-of select="codegen:getPropertyName($table, substring(@xpath,2))"/>
                </xsl:for-each>);

                <xsl:value-of select="$var-name" />._related<xsl:value-of select="$class-name" /> = <xsl:value-of select="$class-name" />( this );

                }

                return <xsl:value-of select="$var-name" />;
                }

                public function set <xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,0)" />(value:<xsl:value-of select="codegen:getClassName(@name)" />):void
                {
                <xsl:value-of select="$var-name" /> = value;
                <xsl:value-of select="$var-name" />._related<xsl:value-of select="$class-name" /> = <xsl:value-of select="$class-name" />(this);
    
                }
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="var-name" select="concat('_',codegen:getChildProperty($table,@name,$fk,1))" />
                <xsl:variable name="hidden-property" select="codegen:getChildProperty($table,@name,$fk,1)" />

                // one to many relation
                protected var <xsl:value-of select="$var-name" />:ActiveCollection;
                [Bindable(event="loaded")]
                public function get <xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,0)" />():ActiveCollection
                {
                  <xsl:value-of select="$var-name" /> = onChildRelationRequest("<xsl:value-of select="$hidden-property" />",<xsl:value-of select="$var-name" />);
                  
                  return <xsl:value-of select="$var-name" />;
                }
                
            </xsl:otherwise>
            </xsl:choose>
            
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>

      <xsl:if test="xs:keyref">
        protected override function onDirtyChanged():void
        {
          <xsl:for-each select="xs:keyref">
            <xsl:variable name="key" select="@name" />
            <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
            
            if(_<xsl:value-of select="codegen:getParentProperty($table,$parent-table,$key,1)"/> != null)
              _<xsl:value-of select="codegen:getParentProperty($table,$parent-table,$key,1)"/>.onChildChanged(this);
          </xsl:for-each>
        }
      </xsl:if>



      public override function prepareToSend(identityMap:IdentityMap, cascade:Boolean = false):Object
      {

      if( identityMap.exists( ActiveRecordUID ) )
      return identityMap.extract( ActiveRecordUID );

      var activeRecord:<xsl:value-of select="$class-name"/> = new <xsl:value-of select="$class-name"/>();

      activeRecord.ActiveRecordUID = this.ActiveRecordUID;

      identityMap.add( activeRecord , false);

      <xsl:for-each select="xs:keyref">
        <xsl:variable name="property" select="codegen:getParentProperty($table, key('table',@refer)/@name, @name,1)" />

        if( this._<xsl:value-of select="$property"/> != null )
        {
        activeRecord._<xsl:value-of select="$property"/> =
        this._<xsl:value-of select="codegen:getParentProperty($table, key('table',@refer)/@name, @name,1)" />.prepareToSend(identityMap,false) as <xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)"/>;
      }
    </xsl:for-each>

    <xsl:for-each select="xs:complexType/xs:attribute[not(concat('@',@name) = key('fk',$class-name)/@xpath)]">
      <xsl:variable name="property" select="codegen:getPropertyName($table,@name)" />
      activeRecord.<xsl:value-of select="$property"/> = this.<xsl:value-of select="$property"/>;
    </xsl:for-each>

    <xsl:if test="key('dependent',current()/xs:key/@name)">
      if(cascade)
      {
      <xsl:for-each select="key('dependent',current()/xs:key/@name)">
        <xsl:variable name="child-table" select="@name" />
        <xsl:variable name="child-table-pk" select="xs:key/@name" />

        <xsl:for-each select="xs:keyref[@refer = $pk]">
          <xsl:variable name="fk" select="@name" />
          <xsl:variable name="child-var" select="concat(codegen:getFunctionParameter($child-table),position())" />
          <xsl:for-each select="key('table',$child-table-pk)">
            <xsl:choose>
              <xsl:when test="count(xs:key/xs:field[@xpath = key('fkByName',$fk)/@xpath]) = count(xs:key/xs:field)">

                if( this._<xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,1)"/> != null )
                {
                activeRecord._<xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,1)"/> = <xsl:value-of select="codegen:getClassName($child-table)"/>(this._<xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,1)"/>.prepareToSend(identityMap, true));
                      activeRecord._<xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,1)"/>._<xsl:value-of select="codegen:getParentProperty($child-table,$table,$fk,1)" /> = activeRecord;
                      }
                    </xsl:when>
                    <xsl:otherwise>
                      for each(var <xsl:value-of select="$child-var" /> :<xsl:value-of select="codegen:getClassName(@name)"/> in <xsl:value-of select="concat('_',codegen:getChildProperty($table,$child-table,$fk,1))"/>)
                      {
                        if(<xsl:value-of select="$child-var" />.IsDirty)
                        {
                          var <xsl:value-of select="$child-var" />Extract:Object = <xsl:value-of select="$child-var" />.prepareToSend(identityMap, true);
                      <xsl:value-of select="$child-var" />Extract._<xsl:value-of select="codegen:getParentProperty($child-table,$table,$fk,1)" /> = activeRecord;

                          activeRecord.<xsl:value-of select="codegen:getChildProperty($table,$child-table,$fk,0)"/>.addItem(<xsl:value-of select="$child-var" />Extract);
                        }
                      }
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each>
            }
          </xsl:if>



      return activeRecord;
      }

      <xsl:if test="key('dependent',current()/xs:key/@name)">
          public override function extractChilds():Array
          {
          var childs:Array = new Array();

          <xsl:for-each select="key('dependent',current()/xs:key/@name)">
            <xsl:variable name="child-table" select="@name" />
            <xsl:variable name="child-table-pk" select="xs:key/@name" />
            <xsl:for-each select="xs:keyref[@refer = $pk]">
              <xsl:variable name="fk" select="@name" />
              <xsl:variable name="child-var" select="concat(codegen:getFunctionParameter($child-table),position())" />

              <xsl:for-each select="key('table',$child-table-pk)">
                <xsl:choose>
                  <xsl:when test="count(xs:key/xs:field[@xpath = key('fkByName',$fk)/@xpath]) = count(xs:key/xs:field)"></xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="hidden-property" select="codegen:getChildProperty($table,@name,$fk,1)" />
                    if(this["<xsl:value-of select="$hidden-property"/>"])
                    {
                      for each(var <xsl:value-of select="$child-var"/> :ActiveRecord in this["<xsl:value-of select="$hidden-property"/>"] as Array)
                      childs.push(<xsl:value-of select="$child-var"/>);
                    }
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>

          return childs;
          }
        </xsl:if>

      public override function applyFields(object:Object):void
      {
        try
        {
        disableLazyLoading();

        <xsl:for-each select="xs:complexType/xs:attribute">
            <xsl:variable name="property" select="codegen:getPropertyName($table,@name)" />

            <xsl:if test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
              <xsl:choose>
                <xsl:when test="not(../../xs:key/xs:field[@xpath = concat('@',current()/@name)])">
                  <xsl:value-of select="$property"/> = object.<xsl:value-of select="$property"/>;
                </xsl:when>
                <xsl:otherwise>
                  if(!IsPrimaryKeyInitialized)
                    <xsl:value-of select="$property"/> = object.<xsl:value-of select="$property"/>;
                </xsl:otherwise>
              </xsl:choose>

            </xsl:if>
          </xsl:for-each>


          <xsl:for-each select="xs:keyref">
            <xsl:variable name="parent-table" select="key('table',@refer)/@name" />
            <xsl:value-of select="codegen:getParentProperty($table,$parent-table, @name,0)" /> =
            object.<xsl:value-of select="codegen:getParentProperty($table,$parent-table, @name,0)" />;
          </xsl:for-each>
        
            _uri = null;
            _isPrimaryKeyAffected = true;
            IsDirty = false;
          }
          finally
          {
            enableLazyLoading();
          }
        }

        protected override function get dataMapper():DataMapper
        {
          return DataMapperRegistry.Instance.<xsl:value-of select="$class-name"/>;
        }
        
       
        public override function getURI():String
        {

          if(_uri == null)
          {
           _uri = "<xsl:value-of select="../../../@name"/>.<xsl:value-of select="@name"/>" 
            <xsl:for-each select="xs:key/xs:field">
              + "." + <xsl:value-of select="codegen:getPropertyName($table,substring(@xpath,2))" />.toString()
            </xsl:for-each>;
          }
           
          return _uri;
        }
      }

      }
    </file>
    <file name="{concat('_',$class-name,'DataMapper')}.as" override="true">
      package <xsl:value-of select="codegen:getClientNamespace()" />.Codegen
      {
        import weborb.data.*;

        import mx.rpc.AsyncToken;
        import mx.rpc.Responder;
        import mx.rpc.events.ResultEvent;
        import mx.rpc.remoting.RemoteObject;

        import <xsl:value-of select="codegen:getClientNamespace()" />.<xsl:value-of select="$class-name" />;
        import <xsl:value-of select="codegen:getClientNamespace()" />.<xsl:value-of select="codegen:getClassName( ../../../@name )" />Db;        
        import <xsl:value-of select="codegen:getClientNamespace()" />.DataMapperRegistry;
      
        public dynamic class _<xsl:value-of select="$class-name"/>DataMapper extends DataMapper
        {
        
          public override function createActiveRecordInstance():ActiveRecord
          {
            return new <xsl:value-of select="$class-name"/>();
          }
        
          protected override function get RemoteClassName():String
          {
            return "<xsl:value-of select="codegen:getServerNamespace()" />.<xsl:value-of select="$class-name"/>DataMapper";
          }
          
          public override function getDatabase():Database
          {
            return <xsl:value-of select="codegen:getClassName(../../../@name)" />Db.Instance;
          }
          
      		public function load(<xsl:value-of select="codegen:getFunctionParameter($class-name)" />:<xsl:value-of select="$class-name"/>, responder:Responder = null):<xsl:value-of select="$class-name"/>
          {
            
              if(!<xsl:value-of select="codegen:getFunctionParameter($class-name)" />.IsPrimaryKeyInitialized)
          	    throw new Error("Record can be loaded only with initialized primary key");
          
              if(IdentityMap.global.exists(<xsl:value-of select="codegen:getFunctionParameter($class-name)" />.getURI()))
              {
                <xsl:value-of select="codegen:getFunctionParameter($class-name)" /> = <xsl:value-of select="$class-name"/>(IdentityMap.global.extract(<xsl:value-of select="codegen:getFunctionParameter($class-name)" />.getURI()));
                
                if(<xsl:value-of select="codegen:getFunctionParameter($class-name)" />.IsLoaded || <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.IsLoading)
                  return <xsl:value-of select="codegen:getFunctionParameter($class-name)" />;
      
              } 
              else
               IdentityMap.global.add(<xsl:value-of select="codegen:getFunctionParameter($class-name)" />);

              <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.IsLoading = true;
      
              var asyncToken:AsyncToken = new DatabaseAsyncToken(createRemoteObject().findByPrimaryKey(
                <xsl:for-each select="xs:key/xs:field">
                  <xsl:value-of select="codegen:getFunctionParameter($class-name)" />.<xsl:value-of select="codegen:getPropertyName($table,substring(@xpath,2))"/>
                  <xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>),null,<xsl:value-of select="codegen:getFunctionParameter($class-name)" />);
            
              return <xsl:value-of select="codegen:getFunctionParameter($class-name)" />;
          }
          
      
          public function findByPrimaryKey(  <xsl:for-each select="xs:complexType/xs:attribute[concat('@',@name) = key('pk',$table)/@xpath]">
            <xsl:value-of select="codegen:getFunctionParameter(@name)" />
            <xsl:text>:</xsl:text><xsl:value-of select="codegen:getASDataType(@type)" />
            <xsl:if test="position() != last()">,</xsl:if>
          </xsl:for-each>):<xsl:value-of select="$class-name" />
          {
          <!--
            var activeRecord:<xsl:value-of select="$class-name"/> = createInstanceByPrimaryKey(
              <xsl:for-each select="xs:complexType/xs:attribute[concat('@',@name) = key('pk',$table)/@xpath]">
                <xsl:value-of select="codegen:getFunctionParameter(@name)" />
                <xsl:if test="position() != last()">,</xsl:if>
              </xsl:for-each>);
          -->
            var activeRecord:<xsl:value-of select="$class-name"/> = new <xsl:value-of select="$class-name"/>();
      
            <xsl:for-each select="xs:key/xs:field">
              activeRecord.<xsl:value-of select="codegen:getPropertyName($table,substring(@xpath,2))"/> = <xsl:value-of select="codegen:getFunctionParameter(substring(@xpath,2))"/>;
            </xsl:for-each>
      
            return load(activeRecord);
          }
        
        <!--
        public function createInstanceByPrimaryKey( <xsl:for-each select="xs:complexType/xs:attribute[concat('@',@name) = key('pk',$table)/@xpath]">
          <xsl:value-of select="codegen:getFunctionParameter(@name)" />
          <xsl:text>:</xsl:text>
          <xsl:value-of select="codegen:getASDataType(@type)" />
          <xsl:if test="position() != last()">,</xsl:if>
        </xsl:for-each>):<xsl:value-of select="$class-name" />
          {
            var activeRecord:<xsl:value-of select="$class-name"/> = new <xsl:value-of select="$class-name"/>();

            <xsl:for-each select="xs:key/xs:field">
              activeRecord.<xsl:value-of select="codegen:getPropertyName($table,substring(@xpath,2))"/> = <xsl:value-of select="codegen:getFunctionParameter(substring(@xpath,2))"/>;
            </xsl:for-each>


            if(IdentityMap.exists(activeRecord.getURI()))
              return IdentityMap.extract(activeRecord.getURI()) as <xsl:value-of select="$class-name" />;
            else
              IdentityMap.add(activeRecord);
              
              
            return activeRecord;
        }
        -->

      public override function loadChildRelation(activeRecord:ActiveRecord,relationName:String, activeCollection:ActiveCollection):void
      {
      var item:<xsl:value-of select="$class-name" /> = <xsl:value-of select="$class-name"/>(activeRecord);
                   
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
                <xsl:variable name="dynamic-function">
                  findBy<xsl:for-each select="key('fkByName',$fk)">
                    <xsl:if test="position() != 1">And</xsl:if>
                    <xsl:value-of select="codegen:getStoredProcedureName(substring(@xpath,2))"/>
                  </xsl:for-each>(
                  <xsl:for-each select="key('pkByElementId',$id)">
                    <xsl:if test="position() != 1">,</xsl:if>
                    item.<xsl:value-of select="codegen:getPropertyName(../../@name,substring(@xpath,2))"/>
                  </xsl:for-each>, activeCollection,getRelationQueryOptions(relationName))
                </xsl:variable>

                if(relationName == "<xsl:value-of select="$hidden-property" />")
                {
                  DataMapperRegistry.Instance.<xsl:value-of select="codegen:getClassName(@name)" />.<xsl:value-of select="$dynamic-function" />;

                  return;
                }
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
         }
        }
      }
    </file>
  </xsl:template>
  
  <xsl:template name="codegen.client.domain">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />

    <file name="{$class-name}.as" override="false">
      package <xsl:value-of select="codegen:getClientNamespace()" />
      {
        import <xsl:value-of select="codegen:getClientNamespace()" />.Codegen.*;
        
        [Bindable]
        [RemoteClass(alias="<xsl:value-of select="concat(codegen:getServerNamespace(),'.',$class-name)" />")]
        public dynamic class <xsl:value-of select="$class-name"/> extends _<xsl:value-of select="$class-name"/>
        {
        
        }
      }
    </file>
    <file name="{$class-name}DataMapper.as" override="false">
      package <xsl:value-of select="codegen:getClientNamespace()" />
      {
        import <xsl:value-of select="codegen:getClientNamespace()" />.Codegen.*;
        
	      public dynamic class <xsl:value-of select="$class-name"/>DataMapper extends _<xsl:value-of select="$class-name"/>DataMapper
	      {

	      }
      }
    </file>
  </xsl:template>

  <xsl:template name="codegen.client.domain.codegen.datamapperregistry">
    <file name="_DataMapperRegistry.as" overwrite="true">
     package <xsl:value-of select="codegen:getClientNamespace()" />.Codegen
     {
      <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
        import <xsl:value-of select="codegen:getClientNamespace()" />.<xsl:value-of select="codegen:getClassName(@name)"/>DataMapper;
      </xsl:for-each>
       public class _DataMapperRegistry
       {
        <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
          <xsl:variable name="class-name" select="codegen:getClassName(@name)" />

          private var m_<xsl:value-of select="codegen:getFunctionParameter(@name)"/>DataMapper:<xsl:value-of select="$class-name"/>DataMapper;

          public function get <xsl:value-of select="$class-name"/>():<xsl:value-of select="$class-name"/>DataMapper
          {
            if(m_<xsl:value-of select="codegen:getFunctionParameter(@name)"/>DataMapper == null )
              m_<xsl:value-of select="codegen:getFunctionParameter(@name)"/>DataMapper = new <xsl:value-of select="$class-name"/>DataMapper();
              
            return m_<xsl:value-of select="codegen:getFunctionParameter(@name)"/>DataMapper;
          }
        </xsl:for-each>    
        }
      }
    </file>

    <file name="_{codegen:getClassName(@name)}Db.as">
      package <xsl:value-of select="codegen:getClientNamespace()" />.Codegen
      {
        import mx.rpc.AsyncToken;
        import mx.rpc.remoting.RemoteObject;
        import weborb.data.DataServiceClient;
        import weborb.data.Database;
        import flash.utils.ByteArray;
        
        public class _<xsl:value-of select="codegen:getClassName(@name)" />Db extends Database
        {
        
          protected override function get RemoteClassName():String
          {
            return "<xsl:value-of select="codegen:getServerNamespace()" />.<xsl:value-of select="codegen:getClassName(@name)" />Db";
          }

          <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='storedprocedure']">
            public function  <xsl:value-of select="codegen:getStoredProcedureName(@name)"/>(
            <xsl:for-each select="xs:complexType/xs:attribute">
              <xsl:value-of select="codegen:getFunctionParameter(@name)" />
              <xsl:text> :</xsl:text>
              <xsl:value-of select="codegen:getASDataType(@type)" />
              <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>):AsyncToken
            {
              var remoteObject:RemoteObject = createRemoteObject();
              
              return remoteObject.<xsl:value-of select="codegen:getStoredProcedureName(@name)"/>(
              <xsl:for-each select="xs:complexType/xs:attribute">
                <xsl:value-of select="codegen:getFunctionParameter(@name)" />
                <xsl:if test="position() != last()">,</xsl:if>
              </xsl:for-each>);
            }
          </xsl:for-each>
        }
      }
    </file>
  </xsl:template>
  <xsl:template name="codegen.client.domain.datamapperregistry">
    <file name="DataMapperRegistry.as" overwrite="true">
      package <xsl:value-of select="codegen:getClientNamespace()" />
      {
        import <xsl:value-of select="codegen:getClientNamespace()" />.Codegen._DataMapperRegistry;

        public class DataMapperRegistry extends _DataMapperRegistry
        {
          		private static var s_instance:DataMapperRegistry;
		          public static function get Instance():DataMapperRegistry
		          {
			          if(s_instance == null)
				          s_instance = new DataMapperRegistry();
          				
			          return s_instance;
		          } 
        }
      }
    </file>
  </xsl:template>
  <xsl:template name="codegen.client.domain.activerecords">
    <file name="ActiveRecords.as" overwrite="true">
      package <xsl:value-of select="codegen:getClientNamespace()" />
      {
        public final class ActiveRecords
        {
          <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
            <xsl:variable name="class-name" select="codegen:getClassName(@name)" />

            public static function get <xsl:value-of select="$class-name"/>():<xsl:value-of select="$class-name"/>DataMapper
            {
              return DataMapperRegistry.Instance.<xsl:value-of select="$class-name"/>;
            }
          </xsl:for-each>
        }
      }
    </file>
    <file name="{codegen:getClassName(@name)}Db.as">
      package <xsl:value-of select="codegen:getClientNamespace()" />
      {
        import <xsl:value-of select="codegen:getClientNamespace()" />.Codegen._<xsl:value-of select="codegen:getClassName(@name)" />Db;
        
        public final class <xsl:value-of select="codegen:getClassName(@name)" />Db extends _<xsl:value-of select="codegen:getClassName(@name)" />Db
        {
          private static var _instance:<xsl:value-of select="codegen:getClassName(@name)" />Db;
          
          public static function get Instance():<xsl:value-of select="codegen:getClassName(@name)" />Db
          {
            if( _instance == null )
              _instance = new <xsl:value-of select="codegen:getClassName(@name)" />Db();
              
            return _instance;
          }
        }
    }
  </file>
  </xsl:template>
</xsl:stylesheet>