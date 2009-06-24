package com.hydraframework.demos.website.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;

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