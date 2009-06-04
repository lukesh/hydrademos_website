package com.hydraframework.demos.website.view.components.waiter.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.demos.website.view.components.waiter.model.WaiterProxy;

	public class WaitCommand extends SimpleCommand {
		public function get proxy():WaiterProxy {
			return WaiterProxy(this.facade.retrieveProxy(WaiterProxy.NAME));
		}

		public function WaitCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.proxy.waitQueueLength++;
			} else if (notification.isResponse()) {
				this.proxy.waitQueueLength--;
			}
		}
	}
}