package com.hydraframework.demos.website.view.components.navigation.primary.view.events {
	import flash.events.Event;

	public class NavigationEvent extends Event {
		public static const NAVIGATE:String = "NavigationEvent.navigate";
		public var url:String;

		public function NavigationEvent(type:String, url:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.url = url;
		}

		override public function clone():Event {
			return new NavigationEvent(type, url, bubbles, cancelable);
		}
	}
}