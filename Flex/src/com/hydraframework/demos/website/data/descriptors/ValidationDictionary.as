package com.hydraframework.demos.website.data.descriptors {
	import com.hydraframework.demos.website.data.interfaces.IValidationDictionary;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import mx.utils.ObjectUtil;

	public class ValidationDictionary extends EventDispatcher implements IValidationDictionary {

		public function ValidationDictionary(target:IEventDispatcher = null) {
			super(target);
		}

		//-----------------------------
		//
		//	Properties
		//
		//-----------------------------

		/**
		 * @private
		 */
		private var _errors:Dictionary = new Dictionary();

		/**
		 * @private
		 * Current number of errors
		 */
		private var _errorCount:int = 0;

		/**
		 * The current number of errors.
		 */
		public function get errorCount():int {
			return _errorCount;
		}

		/**
		 * Check whether the object as a whole is valid.
		 */
		public function get isValid():Boolean {
			return (_errorCount == 0);
		}


		//-----------------------------
		//
		//	Public Methods
		//
		//-----------------------------

		/**
		 * Override this method to perform validation.
		 */
		public function validate():Boolean {
			return this.isValid;
		}

		/**
		 * Check whether a key/field is valid.
		 */
		[Bindable(event="errorChanged")] //Make sure this is also in any interfaces you are using
		public function hasError(key:Object):Boolean {
			for (var currentKey:Object in _errors)
				if (currentKey == key)
					return true;
			return false;
		}

		/**
		 * Records a new error for the supplied key.
		 */
		public function addError(key:Object, errorMessage:String):void {
			_errors[key] = errorMessage;
			_errorCount++;
			this.dispatchEvent(new Event("errorChanged"));
		}

		/**
		 * Returns an array of all the currently recorded errors.
		 */
		public function listErrors():Array {
			var result:Array = [];

			for (var currentKey:Object in _errors)
				result.push(_errors[currentKey]);

			return result;
		}

		/**
		 * Removes any errors for the supplied key. Returns
		 * whether there was an actual record removed.
		 */
		public function removeError(key:Object):Boolean {
			if (!this.hasError(key)) {
				delete _errors[key];
				_errorCount--;
				this.dispatchEvent(new Event("errorChanged"));
				return true;
			} else {
				return false;
			}
		}

		/**
		 * Removes all errors that have been recorded.
		 */
		public function clearErrors():void {
			for (var currentKey:Object in _errors) {
				delete _errors[currentKey];
			}
			_errorCount = 0;
			this.dispatchEvent(new Event("errorChanged"));
		}

	}
}