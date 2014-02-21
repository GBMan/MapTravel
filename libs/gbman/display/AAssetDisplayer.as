package gbman.display {
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	/**
	 * @author csablons
	 */
	public class AAssetDisplayer extends EventDispatcher {
		protected var _asset	:MovieClip;
		
		public function AAssetDisplayer():void {}
		
		/**
		 * Retourne la position x de l'asset.
		 */
		public function get asset():MovieClip {
			return _asset;
		}
		
		/**
		 * Assigne la position x de l'asset.
		 */
		public function set x(n:Number):void {
			asset.x = n;
		}
		/**
		 * Retourne la position x de l'asset.
		 */
		public function get x():Number {
			return asset.x;
		}
		
		/**
		 * Assigne la position y de l'asset.
		 */
		public function set y(n:Number):void {
			asset.y = n;
		}
		/**
		 * Retourne la position y de l'asset.
		 */
		public function get y():Number {
			return asset.y;
		}
		
		/**
		 * Assigne la largeur de l'asset.
		 */
		public function set width(n:Number):void {
			asset.width = n;
		}
		/**
		 * Retourne la largeur de l'asset.
		 */
		public function get width():Number {
			return asset.width;
		}
		
		/**
		 * Assigne la hauteur de l'asset.
		 */
		public function set height(n:Number):void {
			asset.height = n;
		}
		/**
		 * Retourne la hauteur de l'asset.
		 */
		public function get height():Number {
			return asset.height;
		}
		
		/**
		 * Assigne la visibilité de l'asset.
		 */
		public function set visible(b:Boolean):void {
			asset.visible = b;
		}
		/**
		 * Retourne la visibilité de l'asset.
		 */
		public function get visible():Boolean {
			return asset.visible;
		}
	}
}
