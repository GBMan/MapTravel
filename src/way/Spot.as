package way {
	import flash.utils.clearTimeout;
	import gbman.display.AAssetDisplayer;

	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	/**
	 * @author csablons
	 */
	public class Spot extends AAssetDisplayer {
		
		// Données
		private var _prevLocalX		:Number;
		private var _prevLocalY		:Number;
		private var _moved			:Boolean = false;	// true si on a bougé récemment
		private var _baby			:Boolean = true;	// true si le spot vient d'être créé
		private var _idTimeout		:uint;	// true si le spot vient d'être créé
		public var label	:String;
		public var segment1	:Segment;
		public var segment2	:Segment;
		
		/**
		 * Constructeur
		 */
		public function Spot() {
			_asset = new SpotAsset();
			
			_asset.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			
			_idTimeout = setTimeout(_adult, Settings.DUREE_BLOCAGE);
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("way.Spot : "+arguments);
		}
		
		/**
		 * Pour considérer le point comme un vieux point.
		 * C'est une astuce pour gérer le doublic-tap.
		 */
		private function _adult():void {
			clearTimeout(_idTimeout);
			_baby = false;
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseDown(event:MouseEvent):void {
			_trc("### ### ### _onMouseDown(event)");
			
			if (!_baby) {
				event.stopPropagation();
				
				_asset.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
				_asset.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				_asset.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				_asset.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
				_asset.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
				_asset.addEventListener(MouseEvent.RELEASE_OUTSIDE, _onReleaseOutside);
				_prevLocalX = event.localX;
				_prevLocalY = event.localY;
				
				_asset.dispatchEvent(new MapTravelEvent(MapTravelEvent.SPOT_GRABBED, true));
			}
		}
		
		/**
		 * Pour faire glisser le point.
		 */
		private function _onMouseMove(event:MouseEvent):void {
//			_trc("### ### ### _onMouseMove(event)");
			
			var tOffsetX	:Number = event.localX - _prevLocalX;
			var tOffsetY	:Number = event.localY - _prevLocalY;
			
			x += tOffsetX;
			y += tOffsetY;
			
			_prevLocalX = event.localX - tOffsetX;
			_prevLocalY = event.localY - tOffsetY;
			
			if (segment1) {
				segment1.refresh();
			}
			if (segment2) {
				segment2.refresh();
			}
				
			_moved = true;
		}
		
		/**
		 * Pour faire glisser le point et débloquer la carte.
		 */
		private function _onMouseUp(event:MouseEvent):void {
			_trc("### ### ### _onMouseUp(event)");
			if (_moved) {
				var tOffsetX	:Number = event.localX - _prevLocalX;
				var tOffsetY	:Number = event.localY - _prevLocalY;
			
				x += tOffsetX;
				y += tOffsetY;
				
				_prevLocalX = event.localX - tOffsetX;
				_prevLocalY = event.localY - tOffsetY;
			
				if (segment1) {
					segment1.refresh();
				}
				if (segment2) {
					segment2.refresh();
				}
				
				_moved = false;
			}

			_asset.dispatchEvent(new MapTravelEvent(MapTravelEvent.SPOT_RELEASED, true));
			_asset.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_asset.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_asset.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			_asset.removeEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			_asset.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseOut(event:MouseEvent):void {
			_trc("### ### ### _onMouseOut(event)");
			
			_onMouseUp(event);
//			
//			var tOffsetX	:Number = event.localX - _prevLocalX;
//			var tOffsetY	:Number = event.localY - _prevLocalY;
//			
//			x += tOffsetX;
//			y += tOffsetY;
//			
//			_prevLocalX = event.localX - tOffsetX;
//			_prevLocalY = event.localY - tOffsetY;
//			
//			if (segment1) {
//				segment1.refresh();
//			}
//			if (segment2) {
//				segment2.refresh();
//			}
//				
//			_moved = true;
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onReleaseOutside(event:MouseEvent):void {
			_trc("### ### ### _onReleaseOutside(event)");
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseOver(event:MouseEvent):void {
			_trc("### ### ### _onMouseOver(event)");
		}
	}
}