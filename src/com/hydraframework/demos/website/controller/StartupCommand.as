package com.hydraframework.demos.website.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;

	/**
	 * The StartupCommand is typically mapped to the Facade.REGISTER
	 * Notification, and should essentially "kick off" your application.
	 * 
	 * For this demo, there really isn't any preflight stuff we need to
	 * accomplish, and we can't do anything before the ConfigurationManager
	 * does it's job. For this demo, we just load what we need after the
	 * ConfigurationManager.CONFIGURATION_COMPLETE Notification is sent--
	 * check out the ConfigurationCompleteCommand.
	 * 
	 * @author fran
	 */
	public class StartupCommand extends SimpleCommand {

		public function StartupCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				trace("StartupCommand executing...");
			}
		}
	}
}