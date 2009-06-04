package com.hydraframework.demos.website.data.delegates {
	import com.hydraframework.demos.website.data.interfaces.IUser;
	import com.hydraframework.demos.website.data.interfaces.IUserDelegate;

	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;


	public class UserDelegate implements IUserDelegate {

		public function UserDelegate() {
			_remoteObject = new RemoteObject("GenericDestination");
			_remoteObject.endpoint = "http://desho-server.andculture.local/weborb30/weborb.aspx";
			_remoteObject.source = "ServiceLibrary.UserService";
		}

		private var _remoteObject:RemoteObject;

		/**
		 * Create User
		 */
		public function createUser(userToCreate:IUser):AsyncToken {
			return _remoteObject.createUser(userToCreate);
		}

		/**
		 * Delete User
		 */
		public function deleteUser(userToDelete:IUser):AsyncToken {
			return _remoteObject.deleteUser(userToDelete);
		}

		/**
		 * Retrieve User
		 */
		public function retrieveUser(userId:int):AsyncToken {
			return _remoteObject.retrieveUser(userId);
		}

		/**
		 * Retrieve User List
		 */
		public function retrieveUserList():AsyncToken {
			return _remoteObject.retrieveUserList();
		}

		/**
		 * Update User
		 */
		public function updateUser(userToUpdate:IUser):AsyncToken {
			return _remoteObject.updateUser(userToUpdate);
		}
	}
}