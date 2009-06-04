<%@ Application Language="C#" %>
<%@ Import Namespace="System.Security.Principal" %>
 
<script runat="server">

    void Application_Start(object sender, EventArgs e) 
    {
        try
        {
           Weborb.Config.ORBConfig config = new Weborb.Config.ORBConfig();
           Weborb.Messaging.RTMPServer server = new Weborb.Messaging.RTMPServer( "default", 2037, 500, config );
           server.start();
           Application[ "weborbMessagingServer" ] = server;                   
        }
        catch( Exception )
        {
        }      
    }
    
    void Application_End(object sender, EventArgs e) 
    {
    
        Weborb.Messaging.RTMPServer server = (Weborb.Messaging.RTMPServer) Application[ "weborbMessagingServer" ];
        
        if( server != null )
            server.shutdown();
            
    }
        
    void Application_Error(object sender, EventArgs e) 
    { 
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e) 
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e) 
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
    
    protected void Application_AuthenticateRequest(Object sender, EventArgs e)
    {
        //When application uses Forms Authentication, it creates FormsIdentity along 
        // with the FormsAuthenticationTicket. The API call below establishes WebORB 
        // principal for the current Forms Authentication request. As a result, 
        // WebORB security can leverage the same user identity created through
        // Forms Authentication
        Weborb.Security.ORBSecurity.AuthenticateRequest();
    }    
       
</script>
