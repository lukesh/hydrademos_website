package com.hydraframework.demos.website.modules.users.controller
{
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.demos.website.data.interfaces.IUser;
	import com.hydraframework.demos.website.data.interfaces.IUserDelegate;
	import com.hydraframework.demos.website.modules.users.UsersFacade;
	import com.hydraframework.demos.website.modules.users.model.UsersProxy;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class CreateUserCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IUserDelegate {
			return new(this.facade.retrieveDelegate(IUserDelegate) as Class)();
		}
		
		public function get proxy():UsersProxy {
			return UsersProxy(this.facade.retrieveProxy(UsersProxy.NAME));
		}

		public function CreateUserCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				var asyncToken:AsyncToken = this.delegate.createUser(IUser(notification.body));
				asyncToken.addResponder(this);
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