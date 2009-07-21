package com.hydraframework.demos.website.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.plugins.navigation.NavigationPlugin;

	/**
	 * In the context of this implementation, the
	 * ConfigurationManager.CONFIGURATION_COMPLETE Notification gets fired when
	 * the ConfigurationManager is finished loading and parsing the external
	 * configuration xml file.
	 *
	 * This command maps to that notification and essentially starts the
	 * application.
	 *
	 * @author fran
	 */
	public class ConfigurationCompleteCommand extends SimpleCommand {

		public function ConfigurationCompleteCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isResponse()) {
				/*
				   It's important to note that the Sitemap class in this website
				   demo is not defined dynamically; rather it's a hierarchy that's
				   hard-coded into the application in the Sitemap class itself.

				   However, this could be dynamically configured and then initialized.

				   The purpose of this is simply to provide a technical demo of the
				   HydraFramework and some very basic implementation examples.
				 */
				this.facade.sendNotification(new Notification(NavigationPlugin.SET_SITEMAP, new Sitemap(), Phase.REQUEST));

				/*
				   Navigate to a blank url, which in this case, is the home page.
				 */
				this.facade.sendNotification(new Notification(NavigationPlugin.NAVIGATE, "", Phase.REQUEST));
			}
		}
	}
}