package indication {
	import gbman.display.AAssetDisplayer;

	import flash.display.MovieClip;
	import flash.text.TextField;
	/**
	 * @author csablons
	 */
	public class Indication extends AAssetDisplayer {
		public var tf			:TextField;
		public var tfVersion	:TextField;
		public var mc			:MovieClip;
		
		/**
		 * Constructeur
		 */
		public function Indication() {
			_asset = new IndicationAsset();
			tf = asset.tf;
			tfVersion = asset.tfVersion;
			mc = asset.mc;
			
			asset.mouseEnabled = false;
			asset.mouseChildren = false;
			
			mc.width = tf.width;
			mc.height = Math.ceil(tf.height);
			
			tfVersion.text = Settings.VERSION;
		}
		
		/**
		 * Modifie la largeur du bloc.
		 * @param n Nouvelle largeur
		 */
		override public function set width(n:Number):void {
			mc.width = tf.width = Math.ceil(n);
			tfVersion.x = mc.width - tfVersion.width;
		}
	}
}