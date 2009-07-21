package com.hydraframework.demos.website.pages.login.view {
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.pages.login.Login;
	import com.hydraframework.plugins.authentication.AuthenticationManager;
	import com.hydraframework.plugins.authentication.data.descriptors.LoginInformation;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IUIComponent;

	public class LoginMediator extends Mediator {
		public static const NAME:String="LoginMediator";

		public function get view():Login {
			return this.component as Login;
		}

		public function LoginMediator(component:IUIComponent=null) {
			super(NAME, component);
		}

		override public function initialize():void {
			super.initialize();

			view.wLogin.addEventListener(MouseEvent.CLICK, handleLoginClick);

		}

		private function handleLoginClick(event:Event):void {
			var loginInfo:LoginInformation=new LoginInformation;
			loginInfo.loginId=view.wLoginId.text;
			loginInfo.password=view.wPassword.text;
			AuthenticationManager.instance.login(loginInfo);
		}
	}
}