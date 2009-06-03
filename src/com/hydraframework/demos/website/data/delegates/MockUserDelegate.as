package com.hydraframework.demos.website.data.delegates {
	import com.hydraframework.demos.website.data.descriptors.User;
	import com.hydraframework.demos.website.data.interfaces.IUser;
	import com.hydraframework.demos.website.data.interfaces.IUserDelegate;

	import flash.utils.setTimeout;

	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;

	use namespace mx_internal;

	public class MockUserDelegate implements IUserDelegate {

		public static var mock_userList:ArrayCollection;

		public function MockUserDelegate() {
			if (mock_userList)
				return;

			mock_userList = new ArrayCollection();

			var user:IUser;
			user = new User();

			user = new User();
			user.userId = 0;
			user.firstName = "Francis";
			user.lastName = "Lukesh";
			mock_userList.addItem(user);

			user = new User();
			user.userId = 1;
			user.firstName = "James";
			user.lastName = "Stevenson";
			mock_userList.addItem(user);

			user = new User();
			user.userId = 2;
			user.firstName = "Winton";
			user.lastName = "De Shong";
			mock_userList.addItem(user);

			user = new User();
			user.userId = 3;
			user.firstName = "Evan";
			user.lastName = "Keller";
			mock_userList.addItem(user);
		}

		public function retrieveUserList():AsyncToken {
			var asyncToken:AsyncToken = new AsyncToken(null);
			var users:ArrayCollection = new ArrayCollection(mock_userList.toArray());

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, users, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function createUser(user:IUser):AsyncToken {
			var asyncToken:AsyncToken = new AsyncToken(null);

			user.userId = mock_userList.length;

			mock_userList.addItem(user);

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success:true}, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function retrieveUser(userId:int):AsyncToken {
			var asyncToken:AsyncToken = new AsyncToken(null);
			var lookupUser:IUser;

			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == userId) {
					break;
				}
			}

			var newUser:IUser = new User();
			newUser.userId = lookupUser.userId;
			newUser.firstName = lookupUser.firstName;
			newUser.lastName = lookupUser.lastName;

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, newUser, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function updateUser(user:IUser):AsyncToken {
			var asyncToken:AsyncToken = new AsyncToken(null);
			var lookupUser:IUser;

			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == user.userId) {
					lookupUser.firstName = user.firstName;
					lookupUser.lastName = user.lastName;
					break;
				}
			}

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success:true}, asyncToken, null));
				}, 200);
			return asyncToken;
		}

		public function deleteUser(user:IUser):AsyncToken {
			var asyncToken:AsyncToken = new AsyncToken(null);
			var lookupUser:IUser;

			for each (lookupUser in mock_userList) {
				if (lookupUser.userId == user.userId) {
					mock_userList.removeItemAt(mock_userList.getItemIndex(lookupUser));
					break;
				}
			}

			setTimeout(function():void {
					asyncToken.mx_internal::applyResult(new ResultEvent(ResultEvent.RESULT, false, true, {success:true}, asyncToken, null));
				}, 200);
			return asyncToken;
		}
	}
}