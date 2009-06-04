package com.hydraframework.demos.website.data.descriptors {
	import com.hydraframework.demos.website.data.interfaces.IUser;

	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[RemoteClass(alias="ServiceLibrary.Descriptors.User")]
	public class User extends EventDispatcher implements IUser {
		public function User(target:IEventDispatcher = null) {
			super(target);
		}

		private var _userId:int;

		public function get userId():int {
			return _userId;
		}

		public function set userId(value:int):void {
			_userId = value;
		}

		private var _firstName:String;

		public function get firstName():String {
			return _firstName;
		}

		public function set firstName(value:String):void {
			_firstName = value;
		}

		private var _lastName:String;

		public function get lastName():String {
			return _lastName;
		}

		public function set lastName(value:String):void {
			_lastName = value;
		}

		private var _requestTime:Time;

		public function get requestTime():Time {
			return _requestTime;
		}

		public function set requestTime(value:Time):void {
			_requestTime = value;
		}
	}
}