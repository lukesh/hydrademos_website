package com.hydraframework.demos.website.pages.users.controller {
	import com.hydraframework.core.mvc.events.Notification;
	import com.hydraframework.core.mvc.interfaces.IFacade;
	import com.hydraframework.core.mvc.patterns.command.SimpleCommand;
	import com.hydraframework.demos.website.pages.users.data.interfaces.IUserDelegate;
	import com.hydraframework.demos.website.pages.users.model.UsersProxy;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;

	public class RetrieveUserListCommand extends SimpleCommand implements IResponder {

		public function get delegate():IUserDelegate {
			var d:IUserDelegate = this.facade.retrieveDelegate(IUserDelegate) as IUserDelegate;
			d.responder = this;
			return d;
		}
		
		public function get proxy():UsersProxy {
			return UsersProxy(this.facade.retrieveProxy(UsersProxy.NAME));
		}

		public function RetrieveUserListCommand(facade:IFacade) {
			super(facade);
		}

		override public function execute(notification:Notification):void {
			if (notification.isRequest()) {
				this.delegate.retrieveUserList();
			}
		}

		public function result(data:Object):void {
			trace("user list retrieved!");
			var users:ArrayCollection;
			this.proxy.users = data.result as ArrayCollection;
		}
		
		public function fault(data:Object):void {
		}
	}
}