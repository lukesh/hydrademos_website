package com.hydraframework.demos.website.modules.login
{
	import mx.core.IUIComponent;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.modules.login.view.LoginMediator;

	public class LoginFacade extends Facade
	{
		public static const NAME:String = "LoginFacade";

		public function LoginFacade(component:IUIComponent=null)
		{
			super(NAME, component);
		}
		
		override public function registerCore():void {
			super.registerCore();
			this.registerMediator(new LoginMediator(this.component));
		}
		
	}
}