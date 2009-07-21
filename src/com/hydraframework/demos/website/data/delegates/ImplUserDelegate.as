package com.hydraframework.demos.website.data.delegates {
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

	/**
	 * This demonstrates an implementation delegate. It's not really, because
	 * it is ALSO a mock delegate in that there is no real server interaction,
	 * however it demonstrates how delegates can be dynamically specified in
	 * the application.
	 * 
	 * In a real application, the implementation delegate would talk to the
	 * server and transform responses into abstract data formats that your
	 * components can use.
	 * 
	 * @author fran
	 */
	public class ImplUserDelegate implements IUserDelegate {

		/**
		 * 
		 * @default 
		 */
		public static var mock_userList:ArrayCollection;
		
		/**
		 * @private
		 * 
		 * Stores the responder object that the delegate will apply results
		 * and faults to.
		 */
		private var _responder:IResponder;
		
		public function set responder(value:IResponder):void {
			_responder = value;
		}

		/**
		 * The delegate maintains a responder property of type IResponder.
		 * When the delegate gets a response from the server, it is responsible
		 * transforming the data and applying it to the responder.
		 */
		public function get responder():IResponder {
			return _responder;
		}
		
		public function ImplUserDelegate() {
			if (mock_userList)
				return;

			mock_userList=new ArrayCollection();

			var user:IUser;

			user=new User();
			user.userId=0;
			user.firstName="Sir Francis";
			user.lastName="Lukesh";
			mock_userList.addItem(user);

			user=new User();
			user.userId=1;
			user.firstName="Sir James";
			user.lastName="Stevenson";
			mock_userList.addItem(user);

			user=new User();
			user.userId=2;
			user.firstName="Sir Winton";
			user.lastName="De Shong";
			mock_userList.addItem(user);

			user=new User();
			user.userId=3;
			user.firstName="Sir Evan";
			user.lastName="Keller";
			mock_userList.addItem(user);

			user=new User();
			user.userId=4;
			user.firstName="Sir Robert";
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