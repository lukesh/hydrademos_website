package com.hydraframework.demos.website.data.interfaces {
	import mx.rpc.AsyncToken;

	public interface IUserDelegate {
		function retrieveUserList():AsyncToken;
		function createUser(user:IUser):AsyncToken;
		function retrieveUser(userId:int):AsyncToken;
		function updateUser(user:IUser):AsyncToken;
		function deleteUser(user:IUser):AsyncToken;
	}
}