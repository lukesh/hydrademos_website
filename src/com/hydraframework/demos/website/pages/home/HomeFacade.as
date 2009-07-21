package com.hydraframework.demos.website.pages.home {
	import mx.core.IUIComponent;
	import com.hydraframework.core.mvc.patterns.facade.Facade;
	import com.hydraframework.demos.website.pages.home.view.HomeMediator;

	public class HomeFacade extends Facade {
		public static const NAME:String="HomeFacade";

		public function HomeFacade(component:IUIComponent=null) {
			super(NAME, component);
		}

		override public function registerCore():void {
			super.registerCore();
			/*
			   Mediators
			 */
			this.registerMediator(new HomeMediator(this.component));
		}

	}
}