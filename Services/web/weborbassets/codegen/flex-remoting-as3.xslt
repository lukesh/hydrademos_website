<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="codegen.xslt"/>
  <xsl:import href="codegen.invoke.xslt"/>

  <xsl:template name="comment.service">
    /***********************************************************************
    The generated code provides a simple mechanism for invoking methods
    on the <xsl:value-of select="@fullname" /> class using WebORB. 
    You can add the code to your Flex Builder project and use the 
    class as shown below:

           import <xsl:value-of select="@fullname" />;
           import <xsl:value-of select="@fullname" />Model;

           [Bindable]
           var model:<xsl:value-of select="@name" />Model = new <xsl:value-of select="@name" />Model();
           var serviceProxy:<xsl:value-of select="@name" /> = new <xsl:value-of select="@name" />( model );
           // make sure to substitute foo() with a method from the class
           serviceProxy.foo();
           
    Notice the model variable is shown in the example above as Bindable. 
    You can bind your UI components to the fields in the model object.
    ************************************************************************/
  </xsl:template>
  <!-- xsl:template name="codegen.info">
<b>What has just happened?</b> You selected a class deployed in WebORB and the console produced a corresponding client-side code to invoke methods on the selected class.<br /><br />
<b>What can the generated code do?</b> The generated code accomplishes several goals:<ul>
<li>Generates ActionScript v3 value object classes for all complex types used in the remote .NET class.</li><li>Generates RemoteObject declaration and handler functions for each corresponding remote method</li><li>Generates a utility wrapper class making it easier to perform remoting calls</li>
</ul><br /><b>What can I do with this code?</b> You can download the code, add it to your Flex Builder (or Flex SDK) project and start invoking your .NET methods. The code is the basic minimum one would need to perform a remote invocation. It includes all the stubs for each remote method. Make sure to add your application logic to the handler functions.<br /><br />
<b>How can I download the code?</b> There is a 'Download Code' button in the bottom right corner. The button fetches a zip file with all the generated source code<br />    
  </xsl:template -->
  
   
  <xsl:template name="codegen.service">
      <file name="{@name}.as">
        <xsl:call-template name="codegen.code" />
      </file>
      <file name="{@name}Model.as">
        <xsl:call-template name="codegen.model" />
      </file>
    <xsl:if test="method[@containsvalues=1]">

    <folder name="testdrive">
      <xsl:for-each select="method[@containsvalues=1]">
        <file name="{@name}Invoke.as">
          <xsl:call-template name="codegen.description">
            <xsl:with-param name="file-name" select="concat(@name,'Invoke.as')" />
          </xsl:call-template>

      package <xsl:value-of select="../@namespace" />.testdrive
      {
      <xsl:if test="//datatype">
        import <xsl:value-of select="../@namespace" />.vo.*;
      </xsl:if>
        import <xsl:value-of select="../@namespace" />.*;
        
        public class <xsl:value-of select="@name" />Invoke
        {
          var m_service:<xsl:value-of select="../@name"/> = new <xsl:value-of select="../@name"/>();
        
          public function Execute():void
          {
            <xsl:call-template name="codegen.invoke.method" />
          }
        }
      }
        </file>   
      </xsl:for-each>
    </folder>

    </xsl:if>

     <xsl:call-template name="codegen.vo.folder" />
  </xsl:template>


  <xsl:template name="codegen.invoke.method.name">
    m_service.<xsl:value-of select="@name"/>
  </xsl:template>
  
  <xsl:template name="codegen.code">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat(@name,'.as')" />
    </xsl:call-template>
    <xsl:call-template name="comment.service" />
    package <xsl:value-of select="@namespace" />
    {
    import mx.rpc.remoting.RemoteObject;
    import mx.controls.Alert;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.collections.ArrayCollection;

    <xsl:if test="//datatype">
    import <xsl:value-of select="@namespace" />.vo.*;      
    </xsl:if>

    public class <xsl:value-of select="@name"/>
    {
      private var remoteObject:RemoteObject;
      private var model:<xsl:value-of select="@name"/>Model; 

      public function <xsl:value-of select="@name"/>( model:<xsl:value-of select="@name"/>Model = null )
      {
        remoteObject  = new RemoteObject("GenericDestination");
        remoteObject.source = "<xsl:value-of select='@fullname'/>";
        <xsl:for-each select="method">
        remoteObject.<xsl:value-of select="@name" />.addEventListener("result",<xsl:value-of select="@name" />Handler);
        </xsl:for-each>
        remoteObject.addEventListener("fault", onFault);
        
        if( model == null )
            model = new <xsl:value-of select="@name"/>Model();
    
        this.model = model;

      }
      
      public function setCredentials( userid:String, password:String ):void
      {
        remoteObject.setCredentials( userid, password );
      }

      public function GetModel():<xsl:value-of select="@name"/>Model
      {
        return this.model;
      }


    <xsl:for-each select="method">
      public function <xsl:value-of select="@name"/>(<xsl:for-each select="arg">
        <xsl:value-of select="@name"/>:<xsl:value-of select="@type" />,
      </xsl:for-each> responder:IResponder = null ):void
      {
        var asyncToken:AsyncToken = remoteObject.<xsl:value-of select="@name"/>(<xsl:for-each select="arg">
          <xsl:if test="position() != 1">,</xsl:if>
          <xsl:value-of select="@name"/>
        </xsl:for-each>);
        
        if( responder != null )
            asyncToken.addResponder( responder );

      }
    </xsl:for-each>
    
    <xsl:for-each select="method">     
      public virtual function <xsl:value-of select="@name" />Handler(event:ResultEvent):void
      {
        <xsl:if test="@type != 'void'">
          var returnValue:<xsl:value-of select="@type" /> = event.result as <xsl:value-of select="@type" />;
          model.<xsl:value-of select="@name" />Result = returnValue;
        </xsl:if>
      }
    </xsl:for-each>
      public function onFault (event:FaultEvent):void
      {
        Alert.show(event.fault.faultString, "Error");
      }
    }
  } 
  </xsl:template>
  
  <xsl:template name="codegen.model">
    <xsl:call-template name="codegen.description">
      <xsl:with-param name="file-name" select="concat(@name,'Model.as')" />
    </xsl:call-template>
    
    package <xsl:value-of select="@namespace" />
    {<xsl:if test="//datatype">
      import <xsl:value-of select="@namespace" />.vo.*;      
      </xsl:if> 
      [Bindable]
      public class <xsl:value-of select="@name"/>Model
      {<xsl:for-each select="method"><xsl:if test="@type != 'void'">     
        public var <xsl:value-of select="@name" />Result:<xsl:value-of select="@type" />;</xsl:if></xsl:for-each>
      }
    }
  </xsl:template>

</xsl:stylesheet>
