package com.hydraframework.demos.website.modules.users {
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.data.delegates.UserDelegate;
	import com.hydraframework.demos.website.modules.users.controller.*;
	import com.hydraframework.demos.website.modules.users.model.UsersProxy;
	import com.hydraframework.demos.website.modules.users.view.UsersMediator;

	import mx.core.IUIComponent;

	public class UsersFacade extends Facade {
		public static const NAME:String = "UsersFacade";
		public static const RETRIEVE_USER_LIST:String = "UsersFacade.retrieveUserList";
		public static const SELECT_USER:String = "UsersFacade.selectUser";
		public static const CREATE_USER:String = "UsersFacade.createUser";
		public static const UPDATE_USER:String = "UsersFacade.updateUser";
		public static const DELETE_USER:String = "UsersFacade.deleteUser";

		public function UsersFacade(component:IUIComponent = null) {
			super(NAME, component);
		}

		override public function registerCore():void {
			super.registerCore();
			/*
			   Delegates
			 */
			//this.registerDelegate(MockUserDelegate);
			this.registerDelegate(UserDelegate);
			/*
			   Proxies
			 */
			this.registerProxy(new UsersProxy());
			/*
			   Mediators
			 */
			this.registerMediator(new UsersMediator(this.component));
			/*
			   Commands
			 */
			this.registerCommand(UsersFacade.RETRIEVE_USER_LIST, RetrieveUserListCommand);
			this.registerCommand(UsersFacade.SELECT_USER, SelectUserCommand);
			this.registerCommand(UsersFacade.CREATE_USER, CreateUserCommand);
			this.registerCommand(UsersFacade.UPDATE_USER, UpdateUserCommand);
			this.registerCommand(UsersFacade.DELETE_USER, DeleteUserCommand);
		}
	}
}