package com.hydraframework.demos.website.modules.login.view
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.events.Phase;
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.modules.login.Login;
	import com.hydraframework.plugins.navigation.NavigationPlugin;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IUIComponent;

	public class LoginMediator extends Mediator
	{
		public static const NAME:String = "LoginMediator";
		
		public function get view():Login {
			return this.component as Login;
		}

		public function LoginMediator(component:IUIComponent=null)
		{
			super(NAME, component);
		}
		
		override public function initialize():void {
			super.initialize();
			
			view.wLogin.addEventListener(MouseEvent.CLICK, handleLoginClick);
			AuthenticationManager.getInstance().addEventListener(AuthenticationManager.LOGIN_COMPLETE, loginCompleted, false, 0, true);
			
		}

		private function handleLoginClick(event:Event):void {
			var loginInfo:LoginInformation = new LoginInformation;
			loginInfo.loginId = view.wLoginId.text;
			loginInfo.password = view.wPassword.text;
			AuthenticationManager.getInstance().login(loginInfo);
		}
		
		private function loginCompleted(event:Event):void
		{
			if (AuthenticationManager.getInstance().isLoggedOn)
			{
				// succeeded
				view.wPassword.text = "";
				this.sendNotification(new Notification(NavigationPlugin.NAVIGATE, "",Phase.REQUEST, true, false));				
			}
			else
			{
				// failed
				view.wErrorMessage.text = "Unknown user or password";
			}
		}
	}
}