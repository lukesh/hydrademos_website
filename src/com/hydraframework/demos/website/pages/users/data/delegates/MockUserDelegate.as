package com.hydraframework.demos.website.pages.users.data.delegates {
	import com.hydraframework.demos.website.pages.users.data.descriptors.User;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUser;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUserDelegate;
	
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;
	use namespace mx_internal;

	public class MockUserDelegate implements IUserDelegate {

		public static var mock_userList:ArrayCollection;

		private var _responder:IResponder;
		public function set responder(value:IResponder):void {
			_responder = value;
		}
		public function get responder():IResponder {
			return _responder;
		}
		
		/**
		 * This demonstrates a mock delegate. The purpose of a mock delegate
		 * is to abstract the process of interacting with data from the actual
		 * action of talking to a server. This allows you to create testable, 
		 * encapsulated components, where you can specify server interactions
		 * seperately at implementation time.
		 * 
		 * @author fran
		 */
		public function MockUserDelegate() {
			if (mock_userList)
				return;

			mock_userList=new ArrayCollection();

			var user:IUser;

			user=new User();
			user.userId=0;
			user.firstName="Francis";
			user.lastName="Lukesh";
			mock_userList.addItem(user);

			user=new User();
			user.userId=1;
			user.firstName="James";
			user.lastName="Stevenson";
			mock_userList.addItem(user);

			user=new User();
			user.userId=2;
			user.firstName="Winton";
			user.lastName="De Shong";
			mock_userList.addItem(user);

			user=new User();
			user.userId=3;
			user.firstName="Evan";
			user.lastName="Keller";
			mock_userList.addItem(user);

			user=new User();
			user.userId=4;
			user.firstName="Robert";
			user.lastName="Weiman";
			mock_userList.addItem(user);
		}

		public function retrieveUserList():void {
			var asyncToken:AsyncToken=new AsyncToken(null);
			var users:ArrayCollection=new ArrayCollection(mock_userList.toArray());

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, users, asyncToken, null));
				}, 1000);
		}

		public function createUser(user:IUser):void {
			var asyncToken:AsyncToken=new AsyncToken(null);

			user.userId=mock_userList.length;

			mock_userList.addItem(user);

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success: true}, asyncToken, null));
				}, 1000);
		}

		public function retrieveUser(userId:int):void {
			var asyncToken:AsyncToken=new AsyncToken(null);
			var lookupUser:IUser;
			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == userId) {
					break;
				}
			}

			var newUser:IUser=new User();
			newUser.userId=lookupUser.userId;
			newUser.firstName=lookupUser.firstName;
			newUser.lastName=lookupUser.lastName;

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, newUser, asyncToken, null));
				}, 1000);
		}

		public function updateUser(user:IUser):void {
			var asyncToken:AsyncToken=new AsyncToken(null);
			var lookupUser:IUser;
			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == user.userId) {
					lookupUser.firstName=user.firstName;
					lookupUser.lastName=user.lastName;
					break;
				}
			}

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success: true}, asyncToken, null));
				}, 1000);
		}

		public function deleteUser(user:IUser):void {
			var asyncToken:AsyncToken=new AsyncToken(null);
			var lookupUser:IUser;
			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == user.userId) {
					mock_userList.removeItemAt(mock_userList.getItemIndex(lookupUser));
					break;
				}
			}

			asyncToken.addResponder(new Responder(function(data:Object):void {
				//
				// Transform / normalize response if necessary
				//
					responder.result(data);
				}, function(info:Object):void {
					responder.fault(info);
				}));

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success: true}, asyncToken, null));
				}, 1000);
		}
	}
}