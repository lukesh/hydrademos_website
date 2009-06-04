<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:codegen="urn:weborb-cogegen-xslt-lib:xslt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  
  <xsl:template name="codegen.service">
      <folder name="controller">
        <xsl:for-each select='method'>
            <file name="{@name}Command.as">
                <xsl:call-template name="codegen.description">
                    <xsl:with-param name="file-name" select="concat(@name,'Command.as')" />
                </xsl:call-template>
                <xsl:call-template name="controller" />
            </file>
        </xsl:for-each>
        <file name="StartupCommand.as">
            <xsl:call-template name="codegen.description">
                <xsl:with-param name="file-name" select="concat('','StartupCommand.as')" />
            </xsl:call-template>
        <xsl:call-template name="startup" />
        </file>
      </folder>
      
      <folder name="view">
        <folder name="components">
            <file name="README.txt">
            Place all UI components in the view/components folder. Each component should have a corresponding mediator.
            Mediators should be placed in the view folder.
            </file>
        </folder>
        <file name="{@name}Mediator.as">
            <xsl:call-template name="codegen.description">
                <xsl:with-param name="file-name" select="concat(@name,'Mediator.as')" />
            </xsl:call-template>
        <xsl:call-template name="mediator" />
        </file>
      </folder>
      
    <folder name="model">
        <folder name="enum">
            <file name="README.txt">
            Place any applicable enumeration definitions in the model/enum folder
            </file>
        </folder>
        <folder name="vo">
        <xsl:if test="//service/datatype">
            <xsl:for-each select="datatype">
              <file name="{@name}.as">
                <xsl:call-template name="codegen.description">
                  <xsl:with-param name="file-name" select="concat(@name,'.as')" />
                </xsl:call-template>
                <xsl:call-template name="vo">
                  <xsl:with-param name="vo" select="concat('','')" />
                </xsl:call-template>
              </file>
            </xsl:for-each>
        </xsl:if>
            <file name="{@name}ResultVO.as">
                <xsl:call-template name="codegen.model">

                </xsl:call-template>
            </file>
        </folder>
        <file name="{@name}Proxy.as">
            <xsl:call-template name="codegen.description">
                <xsl:with-param name="file-name" select="concat(@name,'Proxy.as')" />
            </xsl:call-template>
            <xsl:call-template name="proxy" />
        </file>
    </folder>
    <file name="{@name}Facade.as">
        <xsl:call-template name="codegen.description">
            <xsl:with-param name="file-name" select="concat(@name,'Facade.as')" />
        </xsl:call-template>
        <xsl:call-template name="facade" />
    </file>
  </xsl:template>

  <xsl:template name="vo">
  <xsl:param name="vo" />
    package <xsl:value-of select="//service/@namespace"/>.model.vo
    {     
      [RemoteClass(alias="<xsl:value-of select='@fullname'/>")]
      public class <xsl:value-of select="@name"/><xsl:value-of select="$vo"/>
      {
        <xsl:for-each select="field">
          public var <xsl:value-of select="@name"/>:<xsl:value-of select="@type"/>;
        </xsl:for-each>
        
          public function <xsl:value-of select="@name"/><xsl:value-of select="$vo"/>( <xsl:for-each select="field"><xsl:value-of select="@name"/>:<xsl:value-of select="@type" /> = null<xsl:if test="position() != last()">,</xsl:if></xsl:for-each> )
          {
          <xsl:for-each select="field">
            this.<xsl:value-of select="@name"/> = <xsl:value-of select="@name"/>;
          </xsl:for-each>
          }
      }
    }
  </xsl:template>
  
  <xsl:template name="proxy">
    package <xsl:value-of select="//service/@namespace"/>.model
    {    
      import org.puremvc.interfaces.IProxy;
      import org.puremvc.patterns.proxy.Proxy;
      import org.puremvc.patterns.observer.Notification;
      import <xsl:value-of select="@namespace" />.model.vo.*;
      import <xsl:value-of select="@namespace" />.*;          
      import mx.rpc.remoting.RemoteObject;
      import mx.rpc.events.ResultEvent;
      import mx.rpc.events.FaultEvent;
      import mx.rpc.AsyncToken;  
        
      public class <xsl:value-of select="@name"/>Proxy extends Proxy implements IProxy
      {
        public static const NAME:String = '<xsl:value-of select="@name"/>Proxy';
        private var remoteObject:RemoteObject;
        
        public function <xsl:value-of select="@name"/>Proxy( )
        {
          super( NAME );
          remoteObject  = new RemoteObject("GenericDestination");
          remoteObject.source = "<xsl:value-of select='@fullname'/>";
          <xsl:for-each select="method">
          remoteObject.<xsl:value-of select="@name" />.addEventListener("result",<xsl:value-of select="@name" />Handler);
          </xsl:for-each>
          remoteObject.addEventListener("fault", onFault);        
        }       
        <xsl:for-each select='method'>
        public function <xsl:value-of select="@name"/>( <xsl:for-each select="arg">
        <xsl:value-of select="@name"/>:<xsl:value-of select="@type" /><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>):void
        {
          remoteObject.<xsl:value-of select="@name"/>( <xsl:for-each select="arg"><xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>);                 
        }
        
        public virtual function <xsl:value-of select="@name"/>Handler(event:ResultEvent):void
        {                   
            sendNotification( <xsl:value-of select="../@name"/>Facade.<xsl:value-of select="@name"/>_finished, event.result );
        }       
        </xsl:for-each>     
        public function onFault (event:FaultEvent):void
        {
            sendNotification( <xsl:value-of select="@name"/>Facade.ERROR, event.fault.faultString );
        }       
      }
    }
  </xsl:template>
  
  <xsl:template name="controller">
    package <xsl:value-of select="../@namespace" />.controller
    {
      import org.puremvc.interfaces.ICommand;      
      import org.puremvc.interfaces.INotification;      
      import org.puremvc.patterns.command.SimpleCommand;
      import <xsl:value-of select="../@namespace" />.model.*;

      public class <xsl:value-of select="@name"/>Command extends SimpleCommand implements ICommand
      {
        override public function execute( notification:INotification ) : void   
        {
          var args:Array = notification.getBody() as Array;
          var proxy:<xsl:value-of select="../@name" />Proxy = facade.retrieveProxy( <xsl:value-of select="../@name" />Proxy.NAME ) as <xsl:value-of select="../@name" />Proxy;      
          <xsl:for-each select="arg">
          var <xsl:value-of select="@name"/>:<xsl:value-of select="@type" />;
          </xsl:for-each>   
          if( args != null )
          {
            args.reverse();
            <xsl:for-each select="arg">
            <xsl:value-of select="@name"/> = <xsl:value-of select="@type" />(args.pop());
            </xsl:for-each>
          }
          
          proxy.<xsl:value-of select="@name"/>(<xsl:for-each select="arg"><xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if></xsl:for-each>); 
        }
      }

    }    
  </xsl:template>
  
  <xsl:template name="startup">
    package <xsl:value-of select="@namespace" />.controller
    {
      import org.puremvc.interfaces.ICommand;      
      import org.puremvc.interfaces.INotification;      
      import org.puremvc.patterns.command.SimpleCommand;
      import <xsl:value-of select="@namespace" />.model.*;
      import <xsl:value-of select="@namespace" />.view.*;

      public class StartupCommand extends SimpleCommand implements ICommand
      {
        override public function execute( notification:INotification ) : void   
        {       
          facade.registerProxy( new <xsl:value-of select="@name"/>Proxy() );    
          facade.registerMediator( new <xsl:value-of select="@name"/>Mediator() );
        }
      }

    }    
  </xsl:template>  
  
  <xsl:template name="mediator">
    package <xsl:value-of select="@namespace" />.view
    {
      import org.puremvc.interfaces.IMediator;
      import org.puremvc.interfaces.INotification;
      import org.puremvc.patterns.mediator.Mediator;
      import org.puremvc.patterns.observer.Notification;
      import <xsl:value-of select="@namespace" />.*;
      import <xsl:value-of select="@namespace" />.model.*;
      import mx.controls.Alert;   

      public class <xsl:value-of select="@name"/>Mediator extends Mediator implements IMediator
      {
        private var proxy:<xsl:value-of select="@name"/>Proxy;      
        public static const NAME:String = '<xsl:value-of select="@name"/>Mediator';

        public function <xsl:value-of select="@name"/>Mediator( viewComponent:Object = null )
        {
            super( viewComponent );         
            proxy = facade.retrieveProxy( <xsl:value-of select="@name"/>Proxy.NAME ) as <xsl:value-of select="@name"/>Proxy;            
        }
        
        override public function getMediatorName():String
        {
          return NAME;
        }
        
        override public function listNotificationInterests():Array
        {
          return [
                    <xsl:value-of select="@name"/>Facade.ERROR,
                    <xsl:for-each select='method'>
                    <xsl:value-of select="../@name"/>Facade.<xsl:value-of select="@name"/>_finished<xsl:if test="position() != last()">,
                    </xsl:if></xsl:for-each>
          ];
        }
        
        override public function handleNotification( note:INotification ):void
        {
          switch ( note.getName() )
          {
            case <xsl:value-of select="@name"/>Facade.ERROR:
              Alert.show(note.getBody() as String, "Error");
              break;
            <xsl:for-each select='method'>  
            case <xsl:value-of select="../@name"/>Facade.<xsl:value-of select="@name"/>_finished:
            <xsl:if test="@type != 'void'">
              <xsl:value-of select="../@name"/>Facade.getInstance().<xsl:value-of select="../@name"/>Result.<xsl:value-of select="@name"/>Result = note.getBody() as <xsl:value-of select="@type" />;
            </xsl:if>
              break;    
            </xsl:for-each>                 
          }
        }           
      }

    }    
  </xsl:template> 
  
  <xsl:template name="facade">
    package <xsl:value-of select="@namespace" />
    {
      import org.puremvc.interfaces.IFacade;
      import org.puremvc.patterns.facade.Facade;
      import <xsl:value-of select="@namespace" />.controller.*;
      import <xsl:value-of select="@namespace" />.model.vo.*;     
      import <xsl:value-of select="@namespace" />.*;
        
      public class <xsl:value-of select="@name"/>Facade extends Facade implements IFacade
      {
          public static const STARTUP:String = "startup";
          public static const ERROR:String = "error";         
          <xsl:for-each select='method'>
          public static const <xsl:value-of select="@name"/>:String = "<xsl:value-of select="@name"/>";
          public static const <xsl:value-of select="@name"/>_finished:String = "<xsl:value-of select="@name"/> finished";
          </xsl:for-each>
          
          [Bindable]
          public var <xsl:value-of select="@name"/>Result:<xsl:value-of select="@name"/>ResultVO;
      
          public function <xsl:value-of select="@name"/>Facade() 
          {
            <xsl:value-of select="@name"/>Result = new <xsl:value-of select="@name"/>ResultVO();
          }
          
          public static function getInstance() : <xsl:value-of select="@name"/>Facade 
          {
            if ( instance == null ) instance = new <xsl:value-of select="@name"/>Facade( );
              return instance as <xsl:value-of select="@name"/>Facade;
          }   

          override protected function initializeController( ) : void 
          {
            super.initializeController();   
            
            registerCommand( STARTUP, <xsl:value-of select="@namespace" />.controller.StartupCommand );
            <xsl:for-each select='method'>        
            registerCommand( <xsl:value-of select="@name"/>, <xsl:value-of select="../@namespace" />.controller.<xsl:value-of select="@name"/>Command );
            </xsl:for-each>       
          }
      }
    }    
  </xsl:template>  
  
    <xsl:template name="codegen.model">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat(@name,'ResultVO.as')" />
    </xsl:call-template>
    
    package <xsl:value-of select="@namespace" />.model.vo
    {<xsl:if test="//datatype">
      import <xsl:value-of select="@namespace" />.model.vo.*;      
      </xsl:if> 
      [Bindable]
      public class <xsl:value-of select="@name"/>ResultVO
      {<xsl:for-each select="method"><xsl:if test="@type != 'void'">     
        public var <xsl:value-of select="@name" />Result:<xsl:value-of select="@type" />;</xsl:if></xsl:for-each>
      }
    }
  </xsl:template>

</xsl:stylesheet>
