package com.hydraframework.demos.website {
	import com.hydraframework.core.HydraFramework;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.controller.ConfigurationCompleteCommand;
	import com.hydraframework.demos.website.controller.StartupCommand;
	import com.hydraframework.demos.website.data.delegates.ImplUserDelegate;
	import com.hydraframework.demos.website.model.ApplicationProxy;
	import com.hydraframework.demos.website.view.ApplicationMediator;
	import com.hydraframework.demos.website.view.BreadcrumbMediator;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.configuration.ConfigurationManager;
	import com.hydraframework.plugins.error.ErrorManager;
	import com.hydraframework.plugins.navigation.NavigationPlugin;
	import com.hydraframework.plugins.navigation.PageNavigationPlugin;
	
	import mx.core.IUIComponent;

	public class ApplicationFacade extends Facade {
		public static const NAME:String="ApplicationFacade";

		public function get website():Website {
			return this.component as Website;
		}

		public function ApplicationFacade(component:IUIComponent=null) {
			super(NAME, component);
			
//			HydraFramework.debugLevel = HydraFramework.DEBUG_SHOW_INFO | HydraFramework.DEBUG_SHOW_INTERNALS | HydraFramework.DEBUG_SHOW_WARNINGS; 
		}

		override public function registerCore():void {
			
			/*
			   ================================================================
			   
				   Delegates
				   
				   ------------------------------------------------------------
				   
				   An abstraction of data access that allows for encapsulated 
				   component development and a single point of injection when 
				   they're implemented.
			   
			   ================================================================
			 */
			 
			this.registerDelegate(ImplUserDelegate, true);
			
			/*
			   ================================================================
			   
				   Plugins
				   
				   ------------------------------------------------------------
				   
				   Notification-based mixins that dynamically extend the 
				   funcitonality of HydraMVC component.
			   
			   ================================================================
			 */

			// Browser history management, separation of concerns for application state
			this.registerPlugin(new NavigationPlugin());

			// Lightweight page-based navigation framework that integrates with NavigationPlugin
			// PageNavigationPlugin automatically resolves dependency on NavigationPlugin if we
			// didn't register it above.
			this.registerPlugin(new PageNavigationPlugin(website.wContentContainer));

			/*
			   ================================================================
			   
				   Managers
				   
				   ------------------------------------------------------------
				   
				   Singleton Plugins that maintain application-level state.
			   
			   ================================================================
			 */
			 
			// Robust error logging
			this.registerPlugin(ErrorManager.instance);

			// XML-based application configuration designed for single or multi-developer projects
			this.registerPlugin(ConfigurationManager.instance);

			// User Authentication and Authorization
			this.registerPlugin(AuthenticationManager.instance);

			/*
			   ================================================================
			   
				   Proxies
				   
				   ------------------------------------------------------------
				   
				   Core actors that maintain the state of their data and are
				   responsible for sending Notifications that reflect state
				   changes.
			   
			   ================================================================
			 */
			this.registerProxy(new ApplicationProxy());
			
			/*
			   ================================================================
			   
				   Mediators
				   
				   ------------------------------------------------------------
				   
				   Core actors that define how their view should react to
				   Notifications.
			   
			   ================================================================
			 */
			 
			this.registerMediator(new ApplicationMediator(website));
			this.registerMediator(new BreadcrumbMediator(website.wBreadcrumb));

			/*
			   ================================================================
			   
				   Controller
				   
				   ------------------------------------------------------------
				   
				   Map that registers Commands with Notification names. When
				   a Notification is dispatched, an instance that corresponds
				   with that Notification is created, and executed.
			   
			   ================================================================
			 */
			 
			this.registerCommand(ConfigurationManager.CONFIGURATION_COMPLETE, ConfigurationCompleteCommand);
			this.registerCommand(Facade.REGISTER, StartupCommand);
		}
	}
}