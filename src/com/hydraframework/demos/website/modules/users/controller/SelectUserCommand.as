package com.hydraframework.demos.website.modules.users.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.demos.website.modules.users.data.interfaces.IUser;
	import com.hydraframework.demos.website.modules.users.data.interfaces.IUserDelegate;
	import com.hydraframework.demos.website.modules.users.model.UsersProxy;

	public class SelectUserCommand extends SimpleCommand {
		public function get proxy():UsersProxy {
			return UsersProxy(this.facade.retrieveProxy(UsersProxy.NAME));
		}

		public function SelectUserCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				trace("user selected!");
				this.proxy.selectedUser = IUser(notification.body);
			}
		}
	}
}