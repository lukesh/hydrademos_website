package com.hydraframework.demos.website.view.components.waiter {
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.view.components.waiter.controller.WaitCommand;
	import com.hydraframework.demos.website.view.components.waiter.model.WaiterProxy;
	import com.hydraframework.demos.website.view.components.waiter.view.WaiterMediator;
	
	import mx.core.IUIComponent;

	public class WaiterFacade extends Facade {
		public static const NAME:String = "WaiterFacade";

		public static const WAIT:String = "WaiterFacade.wait";
		public static const WAIT_SHOW:String = "WaiterFacade.waitShow";
		public static const WAIT_HIDE:String = "WaiterFacade.waitHide";
		
		public function WaiterFacade(component:IUIComponent = null) {
			super(NAME, component);
		}

		override public function registerCore():void {
			super.registerCore();
			this.registerProxy(new WaiterProxy());
			this.registerMediator(new WaiterMediator(this.component));
			this.registerCommand(WaiterFacade.WAIT, WaitCommand);
		}
	}
}