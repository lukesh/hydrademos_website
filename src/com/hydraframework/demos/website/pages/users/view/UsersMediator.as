package com.hydraframework.demos.website.pages.users.view {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.patterns.mediator.Mediator;
	import com.hydraframework.demos.website.pages.users.Users;
	import com.hydraframework.demos.website.pages.users.UsersFacade;
	import com.hydraframework.demos.website.pages.users.data.descriptors.User;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUser;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.collections.ArrayCollection;
	import mx.core.IUIComponent;
	import mx.events.ListEvent;

	public class UsersMediator extends Mediator {
		public static const NAME:String="UsersMediator";

		public function get view():Users {
			return this.component as Users;
		}

		public function UsersMediator(component:IUIComponent=null) {
			super(NAME, component);
		}

		override public function initialize():void {
			super.initialize();

			view.wRetrieveUserList.addEventListener(MouseEvent.CLICK, handleRetrieveUserListClick);
			view.wUserList.addEventListener(ListEvent.ITEM_CLICK, handleUserListItemClick);
			view.wSave.addEventListener(MouseEvent.CLICK, handleSaveClick);
			view.wDelete.addEventListener(MouseEvent.CLICK, handleDeleteClick);
			view.wCreate.addEventListener(MouseEvent.CLICK, handleCreateClick);
		}

		override public function handleNotification(notification:Notification):void {
			super.handleNotification(notification);

			switch (notification.name) {
				case UsersFacade.RETRIEVE_USER_LIST:
					if (notification.isRequest()) {
						view.wUserListWaiter.show();
					} else {
						view.wUserListWaiter.hide();
						view.wUserList.dataProvider=ArrayCollection(notification.body);
					}
					break;
				case UsersFacade.SELECT_USER:
					if (notification.isResponse()) {
						view.user=IUser(notification.body);
					}
					break;
			}
		}

		private function handleRetrieveUserListClick(event:Event):void {
			this.sendNotification(new Notification(UsersFacade.RETRIEVE_USER_LIST));
		}

		private function handleUserListItemClick(event:ListEvent):void {
			this.sendNotification(new Notification(UsersFacade.SELECT_USER, IUser(event.itemRenderer.data)));
		}

		private function handleSaveClick(event:MouseEvent):void {
			this.sendNotification(new Notification(UsersFacade.UPDATE_USER, IUser(view.user)));
		}

		private function handleDeleteClick(event:MouseEvent):void {
			this.sendNotification(new Notification(UsersFacade.DELETE_USER, IUser(view.user)));
		}

		private function handleCreateClick(event:MouseEvent):void {
			/*
			   This could and probably should be abstracted to an external process.
			   I would hope that your view does not actually create new descriptors.
			   There are several "right ways" to handle creating new objects, and
			   I'm sorry, but I got lazy before I implemented this process in this 
			   demo. Damn "paying work".
			 */
			var user:IUser=new User();
			user.firstName="New User";
			this.sendNotification(new Notification(UsersFacade.CREATE_USER, user));
		}
	}
}