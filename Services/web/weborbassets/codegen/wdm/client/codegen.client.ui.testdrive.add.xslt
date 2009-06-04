<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
  xmlns:codegen="urn:cogegen-xslt-lib:xslt"
  xmlns:wdm="urn:schemas-themidnightcoders-com:xml-wdm"
  xmlns:msdata="urn:schemas-microsoft-com:xml-msdata"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:template name="codegen.client.ui.testdrive.add">
    <xsl:variable name="class-name" select="codegen:getClassName(@name)" />
    <xsl:variable name="id" select="@id"   />
    <xsl:variable name="pk" select="xs:key/@name" />
    <xsl:variable name="table" select="@name"   />
    <file name="{$class-name}AddView.mxml" override="true" type="xml" addxmlversion="true">
      <mx:TitleWindow
        xmlns:mx="http://www.adobe.com/2006/mxml"
        layout="absolute" width="566" height="440" title="Add New {$class-name}"
        creationComplete="onCreationComplete()"
        close="onClose()"
        showCloseButton="true">
        <mx:Script>
          &lt;![CDATA[
          import <xsl:value-of select="codegen:getClientNamespace()" />.*;
          import mx.controls.Alert;
          import mx.rpc.events.FaultEvent;
          import mx.core.Application;
          import mx.managers.PopUpManager;
          import mx.rpc.AsyncToken;
          private var _model:<xsl:value-of select="$class-name" /> = new <xsl:value-of select="$class-name" />();

          public static function ShowDialog():void
          {
            PopUpManager.createPopUp( DisplayObject(Application.application),
              <xsl:value-of select="$class-name" />AddView, true );
          }

          private function onCreationComplete():void
          {
            PopUpManager.centerPopUp(this);

            <xsl:for-each select="xs:keyref">
              <xsl:variable name="relationName" select="codegen:getParentProperty($table,key('table',@refer)/@name,@name,0)" />
              editor<xsl:value-of select="$relationName"/>.dataProvider =  ActiveRecords.<xsl:value-of select="codegen:getClassName(key('table',@refer)/@name)" />.findAll({PageSize:10});
            </xsl:for-each>

          }

          private function onClose():void
          {
          PopUpManager.removePopUp(this);
          }

          private function onSave():void
          {

          var asyncToken:AsyncToken = _model.save();

          asyncToken.addResponder(new mx.rpc.Responder(
          function(resultEvent:*):void
          {
          onClose();
          },
          function(faultEvent:FaultEvent):void
          {
          Alert.show(faultEvent.fault.faultString);
          }));
          }

          ]]&gt;
        </mx:Script>
        <xsl:for-each select="xs:complexType/xs:attribute[not(@msdata:AutoIncrement='true') and not(codegen:IsBinary(@type))]">
          <xsl:if test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
          <mx:Binding>
            <xsl:attribute name="source"><xsl:choose>
                <xsl:when test="@type = 'xs:boolean'">editor<xsl:value-of select="codegen:getProperty($table,@name)"/>.selected</xsl:when>
                <xsl:when test="@type = 'xs:date' or @type = 'xs:timestamp'">editor<xsl:value-of select="codegen:getProperty($table,@name)"/>.selectedDate</xsl:when>
                <xsl:when test="@type = 'xs:string' or @type = 'xs:anyURI'">editor<xsl:value-of select="codegen:getProperty($table,@name)"/>.text</xsl:when>
                <xsl:otherwise>{Number(editor<xsl:value-of select="codegen:getProperty($table,@name)"/>.text)}</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="destination">_model.<xsl:value-of select="codegen:getProperty($table,@name)"/></xsl:attribute>
          </mx:Binding>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="xs:keyref">
          <xsl:variable name="relationName" select="codegen:getParentProperty($table,key('table',@refer)/@name,@name,0)" />
          <mx:Binding source="{codegen:getClassName(key('table',@refer)/@name)}(editor{$relationName}.selectedItem)" destination="_model.{$relationName}" />
        </xsl:for-each>
          <mx:VBox width="100%" height="100%">
          <mx:Form width="100%"  height="350">
            <xsl:for-each select="xs:keyref">
              <xsl:variable name="relationName" select="codegen:getParentProperty($table,key('table',@refer)/@name,@name,0)" />
              <xsl:for-each select="key('table',@refer)">
                <xsl:variable name="labelField">
                  <xsl:choose>
                    <xsl:when test="xs:complexType/xs:attribute[@type='xs:string']">
                      <xsl:value-of select="xs:complexType/xs:attribute[@type='xs:string']/@name"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="xs:complexType/xs:attribute[0]/@name"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <mx:FormItem label="{codegen:getClassName(@name)}" width="100%">
                  <mx:ComboBox id="editor{$relationName}" labelField="{$labelField}" />
                </mx:FormItem>
              </xsl:for-each>
            </xsl:for-each>
            
            <xsl:for-each select="xs:complexType/xs:attribute[not(@msdata:AutoIncrement='true') and not(codegen:IsBinary(@type))]">
              <xsl:variable name="attribute-name" select="@name" />
              <xsl:variable name="property" select="codegen:getPropertyName($table,@name)" />
              <xsl:if test="not(concat('@',@name) = key('fkByElementId',$id)/@xpath)">
                <mx:FormItem label="{$property}" width="100%">
                  <xsl:if test="@use = 'optional'">
                    <xsl:attribute name="required">true</xsl:attribute>
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="@type = 'xs:boolean'">
                      <mx:CheckBox id="editor{$property}" />
                    </xsl:when>
                    <xsl:when test="@type = 'xs:date' or @type = 'xs:timestamp'">
                      <mx:DateField id="editor{$property}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <mx:TextInput id="editor{$property}" width="100%"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </mx:FormItem>
              </xsl:if>
            </xsl:for-each>

          </mx:Form>
          <mx:ControlBar width="100%" horizontalAlign="right" paddingRight="15">
            <mx:Button label="Cancel" width="90" click="onClose()"/>
            <mx:Button label="Save" width="90" click="onSave()"/>
          </mx:ControlBar>
        </mx:VBox>
      </mx:TitleWindow>
    </file>
    </xsl:template>
</xsl:stylesheet>