package com.hydraframework.demos.website.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.navigation.NavigationPlugin;

	public class ConfigurationCompleteCommand extends SimpleCommand {
		public function ConfigurationCompleteCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isResponse()) {
				this.facade.sendNotification(new Notification(NavigationPlugin.SET_SITEMAP, new Sitemap(), Phase.REQUEST));
				this.facade.sendNotification(new Notification(NavigationPlugin.NAVIGATE, "", Phase.REQUEST));
			}
		}
	}
}