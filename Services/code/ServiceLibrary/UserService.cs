using System;
using System.Collections.Generic;
using System.Text;
using ServiceLibrary.Descriptors;

namespace ServiceLibrary {
	public class UserService {
		
		/// <summary>
		/// Get the current list of users.
		/// </summary>
		/// <returns></returns>
		public List<User> retrieveUserList(){ //~60ms
			List<User> userList = new List<User>();
			for (int x = 0; x <= 1000; x++){
				User currentUser = new User();
				currentUser.userId = x;
				currentUser.firstName = "Winton"+x;
				currentUser.lastName = "DeShong"+x;
				currentUser.requestTime = new Time();
				userList.Add(currentUser);
			}
			return userList;
		}
		
		/// <summary>
		/// Create a new user.
		/// </summary>
		/// <param name="userToCreate"></param>
		/// <returns></returns>
		public User createUser(User userToCreate){
			return userToCreate;
		}
		
		/// <summary>
		/// Retrieve a user record by ID.
		/// </summary>
		/// <param name="userId"></param>
		/// <returns></returns>
		public User retrieveUser(int userId){
			User retrievedUser = new User();
			retrievedUser.userId = userId;
			retrievedUser.firstName = "winton"+userId;
			retrievedUser.lastName = "deshong"+userId;
			retrievedUser.requestTime = new Time();
			return retrievedUser;
		}
		
		/// <summary>
		/// Update properties on the supplied user.
		/// </summary>
		/// <param name="userToUpdate"></param>
		/// <returns></returns>
		public User updateUser(User userToUpdate){
			return userToUpdate;
		}
		
		/// <summary>
		/// Delete the supplied user.
		/// </summary>
		/// <param name="userToDelete"></param>
		/// <returns></returns>
		public User deleteUser(User userToDelete){
			return userToDelete;
		}
		
	}
}