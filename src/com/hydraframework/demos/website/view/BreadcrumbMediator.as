package com.hydraframework.demos.website.view {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.view.components.navigation.breadcrumb.Breadcrumb;
	import com.hydraframework.demos.website.view.components.navigation.primary.view.events.NavigationEvent;
	import com.hydraframework.plugins.navigation.NavigationPlugin;
	import com.hydraframework.plugins.navigation.interfaces.ISitemapItem;
	import com.hydraframework.plugins.navigation.interfaces.ISitemapItemData;
	
	import mx.core.IUIComponent;

	public class BreadcrumbMediator extends Mediator {
		public static const NAME:String = "BreadcrumbMediator";

		public function get breadcrumb():Breadcrumb {
			return this.component as Breadcrumb;
		}

		public function BreadcrumbMediator(component:IUIComponent = null) {
			super(NAME, component);
		}

		override public function initialize():void {
			super.initialize();
			this.breadcrumb.addEventListener(NavigationEvent.NAVIGATE, handleNavigationEvent);
		}
		
		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);
			switch (notification.name) {
				case NavigationPlugin.NAVIGATE:
					if (notification.isResponse()) {
						var sitemapItem:ISitemapItem = ISitemapItem(notification.body);
						var sitemapItemData:ISitemapItemData = ISitemapItemData(sitemapItem.getData());
						this.breadcrumb.breadcrumb = sitemapItemData.getBreadCrumb();
					}
					break;
			}
		}
		
		private function handleNavigationEvent(event:NavigationEvent):void {
			this.sendNotification(new Notification(NavigationPlugin.NAVIGATE, event.url));
			event.stopImmediatePropagation();
		}
	}
}