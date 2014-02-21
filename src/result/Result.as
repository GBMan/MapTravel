package  result{
	import gbman.display.AAssetDisplayer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * @author csablons
	 */
	public class Result extends AAssetDisplayer {
		public var tf	:TextField;
		public var mc	:MovieClip;
		
		/**
		 * Constructeur
		 */
		public function Result() {
			_asset = new ResultAsset();
			tf = asset.tf;
			mc = asset.mc;
			
			asset.mouseEnabled = false;
			asset.mouseChildren = false;
			
			mc.width = tf.width;
			mc.height = tf.height;
		}
	}
}