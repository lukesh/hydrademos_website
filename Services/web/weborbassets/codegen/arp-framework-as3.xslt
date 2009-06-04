<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  <xsl:import href="codegen.invoke.xslt"/>

  <xsl:template name="codegen.invoke.method.name">
    service.<xsl:value-of select="@name"/>
  </xsl:template>
  
  <xsl:template name="codegen.service">
    <xsl:call-template name="codegen.code" />
    <xsl:call-template name="codegen.vo.folder">
      <xsl:with-param name="version" select="3" />
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="codegen.code">
    <folder name="business">
      <xsl:call-template name="service-locator" />
    </folder>
    <folder name="control">
      <xsl:call-template name="controller" />
    </folder>
    <folder name="command">
      <xsl:for-each select="method">
      <xsl:call-template name="command" />      
    </xsl:for-each>      
    </folder>
  </xsl:template>

<xsl:template name="service-locator">
  <file name="ServiceLocator.as">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="'ServiceLocator.as'" />
    </xsl:call-template>
  package <xsl:value-of select="@namespace" />.business
  {
    import org.osflash.arp.ServiceLocatorTemplate;
    import org.osflash.arp.AMF0Service;

    public class ServiceLocator extends ServiceLocatorTemplate
    {
      private static var weborbUrl:String = "<xsl:value-of select='@url'/>";
      private static var s_instance:ServiceLocator;

      function ServiceLocator()
      {
        super();
      }

      public static function getInstance():ServiceLocator
      {
        if(s_instance == null)
          s_instance = new ServiceLocator();

        return s_instance;
      }

      override protected function addServices():void
      {
        var service:AMF0Service = new AMF0Service(weborbUrl, "<xsl:value-of select='@fullname'/>",null);
        addService("<xsl:value-of select='@fullname'/>", service);
      }

    }
  }
  </file>
  </xsl:template>

  <xsl:template name='controller'>
    <file name='{@name}Controller.as'>
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'Controller.as')" />
      </xsl:call-template>
    package <xsl:value-of select="@namespace" />.control
    {
      import org.osflash.arp.ControllerTemplate;
      import org.osflash.arp.*;
      import <xsl:value-of select="@namespace" />.command.*;
      import <xsl:value-of select="@namespace" />.view.*;

      public class <xsl:value-of select='@name'/>Controller extends ControllerTemplate
      {
      private static var s_instance:Controller;

      private function addEventListeners ():void
      {
      //
      // Listen for events from the view. To separate screens may dispatch
      // the same event and these will be handled by the same event handler.
      // No two screens should use the same event for different purposes.
      //
      }

      private function addCommands ():void
      {
      <xsl:for-each select="method">
        addCommand ( "<xsl:value-of select='@name'/>", <xsl:value-of select='@name'/>Command );
      </xsl:for-each>
      }

      public static function getInstance ( appRef:* = null ):<xsl:value-of select='@name'/>Controller
      {
        if ( s_instance == null )
        {
        s_instance = new <xsl:value-of select='@name'/>Controller();

        if(appRef != undefined)
        s_instance.registerApp ( appRef );
      }
        else
        return s_instance;
      }

    }
  </file>
  </xsl:template>
  
  <xsl:template name="command">
    <file name="{@name}Command.as">
      <xsl:call-template name="codegen.description">
        <xsl:with-param name="file-name" select="concat(@name,'Command.as')" />
      </xsl:call-template>
      package <xsl:value-of select="../@namespace" />.command
      {
      
      import mx.rpc.events.ResultEvent;
      import mx.rpc.events.FaultEvent;
      import org.osflash.arp.AMF0Service;
      import org.osflash.arp.AMF0PendingCall;
      import org.osflash.arp.AMF0RelayResponder;

      import <xsl:value-of select="../@namespace" />.business.*;
      <xsl:if test="//datatype">
        import <xsl:value-of select="../@namespace" />.vo.*;
      </xsl:if>

      import flash.utils.describeType;

      public class <xsl:value-of select="@name" />Command
      {
        private var viewRef:*;
        
      public function execute ( viewRef:* ):void
      {
        trace ("<xsl:value-of select='@name' />Command.execute()");

        this.viewRef = viewRef;
        var service:AMF0Service = ServiceLocator.getInstance().getService ( "<xsl:value-of select='../@fullname' />");
        var pendingCall:AMF0PendingCall = service.<xsl:value-of select="@name" />(<xsl:for-each select="arg">
        <xsl:if test="position() != 1">,</xsl:if>
        viewRef.get<xsl:value-of select="@name"/>()
      </xsl:for-each>);

        pendingCall.responder = new AMF0RelayResponder(this, "onResult", "onFault");
      }

      public function onResult(re:ResultEvent):void
      {
      <xsl:if test="@type != 'void'">
        var returnValue:<xsl:value-of select="@type" /> = re.result as <xsl:value-of select="@type" />;
      </xsl:if>
      }

      public function onFault(fe:FaultEvent):void
      {
        trace ("failed: " + fe.fault.message);
      }
      }
      }
    </file>
  </xsl:template>
</xsl:stylesheet>
