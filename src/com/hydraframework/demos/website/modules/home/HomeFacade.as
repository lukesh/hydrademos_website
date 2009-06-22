package com.hydraframework.demos.website.modules.home
{
	import mx.core.IUIComponent;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.modules.home.view.HomeMediator;

	public class HomeFacade extends Facade
	{
		public static const NAME:String = "HomeFacade";

		public function HomeFacade( component:IUIComponent=null)
		{
			super(NAME, component);
		}
		
		override public function registerCore():void {
			super.registerCore();
			/*
			   Delegates
			 */
			//this.registerDelegate(MockUserDelegate);
			/*
			   Proxies
			 */
			//this.registerProxy(new UsersProxy());
			/*
			   Mediators
			 */
			this.registerMediator(new HomeMediator(this.component));
			/*
			   Commands
			 */
			//this.registerCommand(UsersFacade.RETRIEVE_USER_LIST, RetrieveUserListCommand);
			//this.registerCommand(UsersFacade.SELECT_USER, SelectUserCommand);
			//this.registerCommand(UsersFacade.CREATE_USER, CreateUserCommand);
			//this.registerCommand(UsersFacade.UPDATE_USER, UpdateUserCommand);
			//this.registerCommand(UsersFacade.DELETE_USER, DeleteUserCommand);
		}
		
	}
}