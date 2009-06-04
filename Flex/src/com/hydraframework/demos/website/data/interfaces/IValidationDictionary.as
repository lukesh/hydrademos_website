package com.hydraframework.demos.website.data.interfaces {
	import flash.utils.Dictionary;

	public interface IValidationDictionary {
		function get errorCount():int;
		function get isValid():Boolean;
		function addError(key:Object, errorMessage:String):void;
		function clearErrors():void;
		[Bindable(event="errorChanged")]
		function hasError(key:Object):Boolean;
		function listErrors():Array;
		function removeError(key:Object):Boolean;
		function validate():Boolean;
	}
}