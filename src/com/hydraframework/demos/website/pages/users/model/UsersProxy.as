package com.hydraframework.demos.website.pages.users.model {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;
	import com.hydraframework.demos.website.pages.users.UsersFacade;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUser;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;

	public class UsersProxy extends Proxy {
		public static const NAME:String = "UsersProxy";

		private var _users:ArrayCollection;
		
		public function get users():ArrayCollection {
			return _users;
		}
		
		public function set users(value:ArrayCollection):void {
			_users = value;
			this.sendNotification(new Notification(UsersFacade.RETRIEVE_USER_LIST, _users, Phase.RESPONSE));
		}
		
		private var _selectedUser:IUser;
		
		public function get selectedUser():IUser {
			return _selectedUser;
		}
		
		public function set selectedUser(value:IUser):void {
			_selectedUser = value;
			this.sendNotification(new Notification(UsersFacade.SELECT_USER, _selectedUser, Phase.RESPONSE));
		}
		
		private var t : Timer;
		public function UsersProxy(data:Object = null) {
			super(NAME, data);
			
			t = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, handleTimer);
		}
		
		private function handleTimer(event : TimerEvent) : void {
			trace("HI THERE");
		}
		
		override public function initialize() : void {
			t.start();
			trace("USERS PROXY INITIALIZE");
		}
		
		override public function dispose() : void {
			t.stop();
			trace("USERS PROXY DISPOSE");
		}
	}
}