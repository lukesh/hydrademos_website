package com.hydraframework.demos.website.view {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.view.components.navigation.primary.view.events.NavigationEvent;
	import com.hydraframework.plugins.configuration.ConfigurationManager;
	import com.hydraframework.plugins.error.ErrorManager;
	import com.hydraframework.plugins.error.descriptors.ErrorDescriptor;
	import com.hydraframework.plugins.navigation.NavigationPlugin;
	
	import mx.controls.Alert;
	import mx.core.IUIComponent;

	public class ApplicationMediator extends Mediator {
		public static const NAME:String = "ApplicationMediator";
		public function get app():Website {
			return this.component as Website;
		}
		
		public function ApplicationMediator(component:IUIComponent = null) {
			super(NAME, component);
		}
		
		override public function initialize():void {
			super.initialize();
			this.app.addEventListener(NavigationEvent.NAVIGATE, handleNavigationEvent);
		}

		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);

			switch (notification.name) {
				case ConfigurationManager.CONFIGURE:
					if(notification.isResponse()) {
						trace("Application configured:", notification.body);
					}
					break;
				case ErrorManager.ERROR:
					if (notification.isResponse()) {
						Alert.show(ErrorDescriptor(notification.body).message);
						ErrorManager.traceErrors();
					}
					break;
			}
		}
		
		private function handleNavigationEvent(event:NavigationEvent):void {
			this.sendNotification(new Notification(NavigationPlugin.NAVIGATE, event.url));
			event.stopImmediatePropagation();
		}
	}
}