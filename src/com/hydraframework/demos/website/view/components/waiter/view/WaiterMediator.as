package com.hydraframework.demos.website.view.components.waiter.view {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.view.components.waiter.Waiter;
	import com.hydraframework.demos.website.view.components.waiter.WaiterFacade;
	
	import flash.events.Event;
	
	import mx.core.IUIComponent;

	public class WaiterMediator extends Mediator {
		public static const NAME:String = "WaiterMediator";

		public function get view():Waiter {
			return Waiter(this.component);
		}

		public function WaiterMediator(component:IUIComponent = null) {
			super(NAME, component);
		}

		override public function initialize():void {
			super.initialize();
			view.includeInLayout = view.visible = false;
			view.addEventListener("waitShow", handleWaitEvent, false, 0, true);
			view.addEventListener("waitHide", handleWaitEvent, false, 0, true);
		}

		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);
			switch (notification.name) {
				case WaiterFacade.WAIT_SHOW:
					view.includeInLayout = view.visible = true;
					break;
				case WaiterFacade.WAIT_HIDE:
					view.includeInLayout = view.visible = false;
					break;
			}
		}
		
		private function handleWaitEvent(event:Event):void {
			this.sendNotification(new Notification(WaiterFacade.WAIT, null, event.type == "waitShow" ? Phase.REQUEST : Phase.RESPONSE));
		}
	}
}