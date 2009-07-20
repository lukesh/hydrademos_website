package com.hydraframework.demos.website.pages.users.data.interfaces {
	import com.hydraframework.core.registries.delegate.interfaces.IDelegate
	import mx.rpc.AsyncToken;
	
	public interface IUserDelegate extends IDelegate {
		function retrieveUserList():void;
		function createUser(user:IUser):void;
		function retrieveUser(userId:int):void;
		function updateUser(user:IUser):void;
		function deleteUser(user:IUser):void;
	}
}