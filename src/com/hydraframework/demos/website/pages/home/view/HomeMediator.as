package com.hydraframework.demos.website.pages.home.view {
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.demos.website.pages.home.Home;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import mx.core.IUIComponent;
	import flash.events.Event;

	public class HomeMediator extends Mediator {
		public static const NAME:String="HomeMediator";

		public function get view():Home {
			return this.component as Home;
		}

		public function HomeMediator(component:IUIComponent=null) {
			super(NAME, component);
		}

		override public function initialize():void {
			super.initialize();
		}

		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);
		}
	}
}