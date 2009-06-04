package com.hydraframework.demos.website.data.descriptors {
	import com.hydraframework.demos.website.data.interfaces.IUser;

	import flash.events.IEventDispatcher;

	import mx.utils.StringUtil;

	[RemoteClass(alias="ServiceLibrary.Descriptors.User")]
	public class User extends ValidationDictionary implements IUser {
		public function User(target:IEventDispatcher = null) {
			super(target);
		}

		//-----------------------------
		//
		//	Properties
		//
		//-----------------------------

		//userId
		private var _userId:int;

		public function get userId():int {
			return _userId;
		}

		public function set userId(value:int):void {
			_userId = value;
		}

		//firstName
		private var _firstName:String;

		public function get firstName():String {
			return _firstName;
		}

		public function set firstName(value:String):void {
			_firstName = value;
		}

		//lastName
		private var _lastName:String;

		public function get lastName():String {
			return _lastName;
		}

		public function set lastName(value:String):void {
			_lastName = value;
		}


		//requestTime
		private var _requestTime:Time;

		public function get requestTime():Time {
			return _requestTime;
		}

		public function set requestTime(value:Time):void {
			_requestTime = value;
		}

		//-----------------------------
		//
		//	Public Methods
		//
		//-----------------------------
		override public function validate():Boolean {
			this.clearErrors();

			//firstName
			if (_firstName == null || StringUtil.trim(_firstName).length == 0)
				this.addError("firstName", "firstName is required");

			//lastName
			if (_lastName == null || StringUtil.trim(_lastName).length == 0)
				this.addError("lastName", "lastName is required");

			return this.isValid;
		}
	}
}