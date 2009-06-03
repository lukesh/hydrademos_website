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

	public class UpdateUserCommand extends SimpleCommand implements IResponder
	{
		public function get delegate():IUserDelegate {
			return this.facade.retrieveDelegate(IUserDelegate) as IUserDelegate;
		}
		
		public function get proxy():UsersProxy {
			return UsersProxy(this.facade.retrieveProxy(UsersProxy.NAME));
		}

		public function UpdateUserCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				var asyncToken:AsyncToken = this.delegate.updateUser(IUser(notification.body));
				asyncToken.addResponder(this);
			}
		}

		public function result(data:Object):void {
			trace("user updated!");
			this.facade.sendNotification(new Notification(UsersFacade.RETRIEVE_USER_LIST));
		}
		
		public function fault(data:Object):void {
		}
	}
}