package {
	import com.hydraframework.demos.website.modules.home.Home;
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
					new SitemapItemData("com/hydraframework/demos/website/modules/users/Users.swf", 
					[{data:"", label:"Home"}, {data:"users", label:"Users"}]))
					];
		}

		override public function getSitemap():Array {
			return this.sitemap;
		}
	}
}