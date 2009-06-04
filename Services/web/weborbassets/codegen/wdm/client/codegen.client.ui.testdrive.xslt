<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
  
  <xsl:template name="codegen.client.ui.testdrive">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="{$class-name}View.mxml" override="true" type="xml" addxmlversion="true">
      <mx:VBox xmlns:mx="http://www.adobe.com/2006/mxml" width="100%" height="100%" label="Products">
        <mx:Script>
          &lt;![CDATA[
            import mx.controls.Alert;
            import mx.events.CollectionEvent;
            import <xsl:value-of select="codegen:getClientNamespace()" />.<xsl:value-of select="$class-name" />;
            import <xsl:value-of select="codegen:getClientNamespace()" />.ActiveRecords;
            import mx.collections.ArrayCollection;

            [Bindable]
            private var _searchResult:ArrayCollection;

            private var _pageSize:int;

            [Bindable]
            public function set pageSize(value:int):void
            {
            _pageSize = value;

            _searchResult = ActiveRecords.<xsl:value-of select="$class-name" />.findAll({PageSize:_pageSize});
            }

            public function get pageSize():int
            {
              return _pageSize;
            }
            
            private function onAddClick():void
            {
            	<xsl:value-of select="$class-name"/>AddView.ShowDialog();
            }
          ]]&gt;
          </mx:Script>
        <mx:Button label="Add New" click="onAddClick()" />
        <mx:Label text="Table records:" />
          <![CDATA[
        <mx:DataGrid width="100%" height="100%" dataProvider="{_searchResult}" editable="true">
          ]]>
        <mx:columns>
          <mx:DataGridColumn width="70" editable="false">
            <mx:itemRenderer>
              <mx:Component>
                <mx:HBox horizontalAlign="center">
                  <![CDATA[
                    <mx:Button height="15" label="save" enabled="{data.IsDirty}" click="{data.save()}" />
                    ]]>
                </mx:HBox>
              </mx:Component>
            </mx:itemRenderer>
          </mx:DataGridColumn>
          <mx:DataGridColumn width="80" editable="false">
            <mx:itemRenderer>
              <mx:Component>
                <mx:HBox horizontalAlign="center">
                  <![CDATA[
                    <mx:Button height="15" label="remove" enabled="{!data.IsLocked}" click="{data.remove()}" />
                    ]]>
                </mx:HBox>
              </mx:Component>
            </mx:itemRenderer>
          </mx:DataGridColumn>
          <xsl:for-each select="xs:complexType/xs:attribute[not(concat('@',@name) = key('fk',$class-name)/@xpath)]">
            <mx:DataGridColumn headerText="{codegen:getProperty($table,@name)}" dataField="{codegen:getProperty($table,@name)}">
              <xsl:if test="../../xs:key/xs:field[@xpath = concat('@',current()/@name)]">
                <xsl:attribute name="editable">false</xsl:attribute>
              </xsl:if>
            </mx:DataGridColumn>
          </xsl:for-each>
        </mx:columns>
        <![CDATA[
        </mx:DataGrid>
        <mx:Label text="Total records: {_searchResult.length}" />
          ]]>
      </mx:VBox>
    </file>

  </xsl:template>
  <xsl:template name="codegen.client.ui.testdrive.databaseview">
    <file name="{codegen:getClassName(@name)}DbView.mxml" override="true" type="xml" addxmlversion="true">
      <mx:Canvas xmlns:mx="http://www.adobe.com/2006/mxml" width="726" height="650" xmlns:controls="UI.TestDrive.*" creationComplete="onCreationComplete()">
        <mx:Script>
          &lt;![CDATA[
          [Bindable]
          private var currentRecordName:String = "";

          private function changeTable(index:int):void
          {
            vsActiveRecords.selectedIndex = index;
            currentRecordName = vsActiveRecords.selectedChild.label;
            Object(vsActiveRecords.selectedChild).pageSize = Number(cbPageSize.selectedItem);
          }

          private function onCreationComplete():void
          {
            cbPageSize.selectedItem = 40;
            changeTable(0);
          }
          ]]&gt;
        </mx:Script>
        <mx:Binding source="cbPageSize.selectedItem" destination="Object(vsActiveRecords.selectedChild).pageSize" />
        <mx:HBox width="100%" height="100%">
          <mx:VBox height="100%" borderStyle="solid" paddingBottom="10"  paddingTop="10"  shadowDistance="3" cornerRadius="10"  dropShadowEnabled="true" borderThickness="2" backgroundColor="#769dbe" borderColor="#294074" shadowDirection="right" >
            <mx:Label text="Active Records" fontWeight="bold" />
            <mx:Spacer />
            <mx:Canvas bottom="10" top="10" width="250" height="100%"  horizontalScrollPolicy="off">
              <mx:VBox  horizontalScrollPolicy="off" verticalScrollPolicy="off"  height="100%">
            <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
              <xsl:sort select="@name" />
              &lt;mx:LinkButton textAlign="left" width="100%" color="#ffffff" label="<xsl:value-of select="@name" />" click="{changeTable(<xsl:value-of select="position()-1"/>)}" /&gt;
            </xsl:for-each>
              </mx:VBox>
            </mx:Canvas>
          </mx:VBox>
          <mx:VBox width="100%" height="100%" paddingBottom="10" paddingLeft="10" paddingRight="10" paddingTop="10" borderStyle="solid" borderThickness="2" cornerRadius="10" shadowDirection="right" shadowDistance="3" dropShadowEnabled="true" backgroundColor="#769dbe" borderColor="#294074">
            <mx:HBox>
              <mx:Label text="Active Record:"  fontWeight="bold" fontSize="17"/>
              <![CDATA[
              <mx:Label text="{currentRecordName}" fontWeight="bold" fontSize="17" />
              ]]>
            </mx:HBox>
            <mx:HBox width="100%">
              <mx:Spacer width="100%" />
              <mx:VBox>
                <mx:HBox>
                  <mx:Label text="Page size:" />
                  <mx:ComboBox id="cbPageSize">
                    <mx:dataProvider>
                      <mx:Array>
                        <mx:Number>10</mx:Number>
                        <mx:Number>20</mx:Number>
                        <mx:Number>30</mx:Number>
                        <mx:Number>40</mx:Number>
                        <mx:Number>50</mx:Number>
                      </mx:Array>
                    </mx:dataProvider>
                  </mx:ComboBox>
                </mx:HBox>
              </mx:VBox>
            </mx:HBox>
  
            <mx:ViewStack width="100%" height="100%" id="vsActiveRecords">
              <xsl:for-each select="xs:complexType/xs:choice/xs:element[@wdm:DatabaseObjectType='table']">
                <xsl:sort select="@name" />
                &lt;controls:<xsl:value-of select="codegen:getClassName(@name)" />View label="<xsl:value-of select="codegen:getClassName(@name)" />" /&gt;
              </xsl:for-each>
            </mx:ViewStack>
          </mx:VBox>
        </mx:HBox>
      </mx:Canvas>
    </file>
  </xsl:template>
  <xsl:template name="codegen.client.ui.app">
    <file name="testdrive.mxml" type="xml" addxmlversion="true">
    <mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" xmlns:ui="UI.TestDrive.*" backgroundGradientColors="[#ffffff, #ffffff]">
      <xsl:for-each select="/xs:schema/xs:element">
       &lt;ui:<xsl:value-of select="codegen:getClassName(@name)" />DbView width="100%" height="100%" top="20" bottom="20" left="20" right="20" /&gt;   
      </xsl:for-each>
    </mx:Application>      
    </file>
  </xsl:template>
</xsl:stylesheet>