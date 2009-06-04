package com.hydraframework.demos.website.view.components.waiter.model {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.demos.website.view.components.waiter.WaiterFacade;

	public class WaiterProxy extends Proxy {
		public static const NAME:String = "WaiterProxy";

		public function WaiterProxy(data:Object = null) {
			super(NAME, data);
		}
		
		private var _waitShowing:Boolean = false;
		private var _waitQueueLength:int = 0;
		
		public function get waitQueueLength():int {
			return _waitQueueLength;
		}
		
		public function set waitQueueLength(value:int):void {
			_waitQueueLength = value;
			if(_waitQueueLength <= 0) {
				_waitQueueLength = 0;
				if(_waitShowing) {
					_waitShowing = false;					
					this.sendNotification(new Notification(WaiterFacade.WAIT_HIDE));
				}
			} else {
				if(!_waitShowing) {
					_waitShowing = true;
					this.sendNotification(new Notification(WaiterFacade.WAIT_SHOW));
				}
			}
		}
	}
}