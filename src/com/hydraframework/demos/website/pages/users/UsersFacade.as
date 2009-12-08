package com.hydraframework.demos.website.pages.users {
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.pages.users.controller.*;
	import com.hydraframework.demos.website.pages.users.data.delegates.MockUserDelegate;
	import com.hydraframework.demos.website.pages.users.model.UsersProxy;
	import com.hydraframework.demos.website.pages.users.view.UsersMediator;
	
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
			this.registerDelegate(MockUserDelegate);
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
		
		override public function initialize() : void {
			trace("USERS FACADE INITIALIZE");
		}
		
		override public function dispose() : void {
			trace("USERS FACADE DISPOSE");
		}
	}
}