package com.hydraframework.demos.website.model {
	import com.hydraframework.core.mvc.patterns.proxy.Proxy;

	public class ApplicationProxy extends Proxy {
		public static const NAME:String = "ApplicationProxy";

		public function ApplicationProxy(data:Object = null) {
			super(NAME, data);
		}
	}
}