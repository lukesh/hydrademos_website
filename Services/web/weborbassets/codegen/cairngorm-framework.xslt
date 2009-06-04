<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  
  <xsl:template name="codegen.service">
      <folder name="business">
        <file name="{@name}Delegate.as">
          <xsl:call-template name="codegen.description">
            <xsl:with-param name="file-name" select="concat(@name,'Delegate.as')" />
          </xsl:call-template>
          <xsl:call-template name="delegate" />
        </file>
      </folder>
      <folder name="command">
        <xsl:for-each select='method'>
          <file name="{@name}Command.as">
            <xsl:call-template name="codegen.description">
              <xsl:with-param name="file-name" select="concat(@name,'Command.as')" />
            </xsl:call-template>
            <xsl:call-template name="command" />
          </file>
        </xsl:for-each>
      </folder>
    <xsl:if test="//service/datatype">
      <folder name="vo">
        <xsl:for-each select="datatype">
          <file name="{@name}.as">
            <xsl:call-template name="codegen.description">
              <xsl:with-param name="file-name" select="concat(@name,'.as')" />
            </xsl:call-template>
            <xsl:call-template name="vo" />
          </file>
        </xsl:for-each>
      </folder>
    </xsl:if>
  </xsl:template>

  <xsl:template name="vo">
    package <xsl:value-of select="//service/@namespace"/>.vo
    {
      import com.adobe.cairngorm.vo.IValueObject;
      
      [RemoteClass(alias="<xsl:value-of select='@fullname'/>")]
      public class 	<xsl:value-of select="@name"/> implements IValueObject
      {
        <xsl:for-each select="field">
          [Bindable]
          public var <xsl:value-of select="@name"/>:<xsl:value-of select="@type"/>;
        </xsl:for-each>
      }
    }
  </xsl:template>
  
  <xsl:template name="delegate">
    package <xsl:value-of select="@namespace" />.business
    {
      import mx.rpc.IResponder;
      import com.adobe.cairngorm.business.ServiceLocator;
      import mx.rpc.events.FaultEvent;
      import mx.rpc.events.ResultEvent;
      import mx.rpc.AbstractOperation;
    <xsl:if test="//service/datatype">
      import <xsl:value-of select="../@namespace" />.vo.*;
    </xsl:if>
      public class <xsl:value-of select="@name"/>Delegate
      {
        private var responder : IResponder;
        private var service : Object;

        public function <xsl:value-of select="@name"/>Delegate(responder : IResponder )
        {
          this.service = ServiceLocator.getInstance().getRemoteObject( "<xsl:value-of select='@name'/>" );
          this.responder = responder;
        }
        
        <xsl:for-each select='method'>
        public function <xsl:value-of select='@name' />(<xsl:for-each select="arg">
          <xsl:if test="position() != 1">,</xsl:if>
          <xsl:value-of select="@name"/>:<xsl:value-of select="@type" />
        </xsl:for-each>) : void
         {

          var call : Object = service.<xsl:value-of select="@name"/>(<xsl:for-each select="arg">
          <xsl:if test="position() != 1">,</xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:for-each>);
        
          call.addResponder( responder );
        }
        </xsl:for-each>

      }

    }    
  </xsl:template>

  <xsl:template name="command">
    package <xsl:value-of select="../@namespace" />.command
    {
    import mx.rpc.IResponder;
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.controls.Alert;
    import <xsl:value-of select="../@namespace" />.business.*;
    <xsl:if test="//service/datatype">
    import <xsl:value-of select="../@namespace" />.vo.*;
    </xsl:if>
    public class <xsl:value-of select="@name"/>Command implements ICommand, IResponder
    {

    public function execute( event : CairngormEvent) : void
    {
      var delegate : <xsl:value-of select="../@name"/>Delegate = new <xsl:value-of select="../@name"/>Delegate( this );
      delegate.<xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:if test="position() != 1">,</xsl:if>null
      </xsl:for-each>);
    }

    public function result( event : Object ) : void
    {
      <xsl:if test="@type != 'void'">
        var returnValue:<xsl:value-of select="@type" /> = event.result as <xsl:value-of select="@type" />;
      </xsl:if>
    }

    public function fault( event : Object ) : void
    {
      var faultEvent : FaultEvent = FaultEvent( event );
      Alert.show( faultEvent.fault.faultString);
    }

    }

    }
  </xsl:template>

</xsl:stylesheet>
