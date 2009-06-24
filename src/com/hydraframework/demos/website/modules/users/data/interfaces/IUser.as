package com.hydraframework.demos.website.modules.users.data.interfaces {
	import flash.events.IEventDispatcher;

	public interface IUser extends IEventDispatcher {
		function get userId():int;
		function set userId(value:int):void;
		function get firstName():String;
		function set firstName(value:String):void;
		function get lastName():String;
		function set lastName(value:String):void;
	}
}