package com.hydraframework.demos.website {
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.controller.ConfigurationCompleteCommand;
	import com.hydraframework.demos.website.view.ApplicationMediator;
	import com.hydraframework.demos.website.view.BreadcrumbMediator;
	import com.hydraframework.plugins.configuration.ConfigurationManager;
	import com.hydraframework.plugins.error.ErrorManager;
	import com.hydraframework.plugins.navigation.NavigationPlugin;
	import com.hydraframework.plugins.navigation.PageNavigationPlugin;
	
	import mx.core.IUIComponent;

	public class ApplicationFacade extends Facade {
		public static const NAME:String = "ApplicationFacade";

		public function get website():Website {
			return this.component as Website;
		}
		
		public function ApplicationFacade(component:IUIComponent = null) {
			super(NAME, component);
		}

		override public function registerCore():void {
			/*
			   Plugins
			   Notification-based mixins that dynamically extend the funcitonality of HydraMVC component.
			 */
			 
			// Robust error logging
			this.registerPlugin(ErrorManager.getInstance());
			
			// XML-based application configuration designed for single or multi-developer projects
			this.registerPlugin(ConfigurationManager.getInstance());
			
			// Browser history management, separation of concerns for application state
			this.registerPlugin(new NavigationPlugin());
			
			// Lightweight page-based navigation framework that integrates with NavigationPlugin
			// PageNavigationPlugin automatically resolves dependency on NavigationPlugin if we
			// didn't register it above.
			this.registerPlugin(new PageNavigationPlugin(website.wContentContainer));
			
			/*
			   Mediators
			 */
			this.registerMediator(new ApplicationMediator(website));
			this.registerMediator(new BreadcrumbMediator(website.wBreadcrumb));
			/*
			   Controller
			 */
			this.registerCommand(ConfigurationManager.CONFIGURATION_COMPLETE, ConfigurationCompleteCommand);
			
		}
	}
}