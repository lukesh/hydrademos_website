package com.hydraframework.demos.website.data.descriptors {
	import flash.events.IEventDispatcher;
	import com.hydraframework.demos.website.pages.users.data.descriptors.User;

	public class ImplUser extends User {
		public function ImplUser(target:IEventDispatcher=null) {
			super(target);
		}
	}
}