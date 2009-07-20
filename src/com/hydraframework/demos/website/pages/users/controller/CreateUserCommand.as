package com.hydraframework.demos.website.pages.users.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.demos.website.pages.users.UsersFacade;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUser;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUserDelegate;
	import com.hydraframework.demos.website.pages.users.model.UsersProxy;
	
	import mx.rpc.IResponder;

	public class CreateUserCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IUserDelegate {
			var d:IUserDelegate = this.facade.retrieveDelegate(IUserDelegate) as IUserDelegate;
			d.responder = this;
			return d;
		}
		
		public function get proxy():UsersProxy {
			return UsersProxy(this.facade.retrieveProxy(UsersProxy.NAME));
		}

		public function CreateUserCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.delegate.createUser(IUser(notification.body));
			}
		}

		public function result(data:Object):void {
			trace("user created!");
			this.facade.sendNotification(new Notification(UsersFacade.RETRIEVE_USER_LIST));
		}
		
		public function fault(data:Object):void {
		}
	}
}