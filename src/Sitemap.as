package {
	import com.hydraframework.demos.website.pages.home.Home;
	import com.hydraframework.demos.website.pages.login.Login;
	import com.hydraframework.plugins.navigation.descriptors.SitemapItem;
	import com.hydraframework.plugins.navigation.interfaces.ISitemap;
	import com.hydraframework.plugins.navigation.model.AbstractSitemap;
	import com.hydraframework.plugins.navigation.model.SitemapItemData;

	public class Sitemap extends AbstractSitemap implements ISitemap {
		private var sitemap:Array;

		public function Sitemap() {
			super();
			sitemap=[
				new SitemapItem("", "website.com", new SitemapItemData(Home)),
				new SitemapItem("users", "website.com - Users", 
					new SitemapItemData("com/hydraframework/demos/website/pages/users/Users.swf", 
					[{data:"", label:"Home"}, {data:"users", label:"Users"}], null, true)),
				new SitemapItem("login", "website.com - Login",
					new SitemapItemData(Login))
					]
		}

		override public function getSitemap():Array {
			return this.sitemap;
		}
	}
}