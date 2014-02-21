package way {
	import gbman.display.AAssetDisplayer;

	import flash.events.MouseEvent;
	/**
	 * @author csablons
	 */
	public class Spot extends AAssetDisplayer {
		
		// Données
		private var _prevLocalX		:Number;
		private var _prevLocalY		:Number;
		private var _moved			:Boolean = false;	// true si on a bougé récemment
		public var label	:String;
		public var segment1	:Segment;
		public var segment2	:Segment;
		
		/**
		 * Constructeur
		 */
		public function Spot() {
			_asset = new SpotAsset();
			
			_asset.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("way.Spot : "+arguments);
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseDown(event:MouseEvent):void {
			_trc("### ### ### _onMouseDown(event)");
			
			event.stopPropagation();
			
			_asset.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_asset.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_asset.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
			_asset.addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
			_asset.addEventListener(MouseEvent.RELEASE_OUTSIDE, _onReleaseOutside);
			_prevLocalX = event.localX;
			_prevLocalY = event.localY;
			
			dispatchEvent(new MapTravelEvent(MapTravelEvent.SPOT_GRABBED, true));
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

			dispatchEvent(new MapTravelEvent(MapTravelEvent.SPOT_RELEASED, true));
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseOut(event:MouseEvent):void {
			_trc("### ### ### _onMouseOut(event)");
			
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