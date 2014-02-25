package way {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author csablons
	 */
	public class Segment extends Sprite {
		
		public var spot1	:Spot;
		public var spot2	:Spot;
		
		public function Segment(spot1:Spot, spot2:Spot) {
			mouseChildren = false;
			this.spot1 = spot1;
			this.spot2 = spot2;
			_draw();
			
			addEventListener(MouseEvent.CLICK, _onClick);
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("way.Segment : "+arguments);
		}
		
		/**
		 * Pour redessinner le segment.
		 */
		public function refresh():void {
			_draw();
		}
		
		/**
		 * 
		 */
		private function _draw():void {
			graphics.clear();
			graphics.lineStyle(4, 0xFF0000, 1, true);
			graphics.moveTo(spot1.x, spot1.y);
			graphics.lineTo(spot2.x, spot2.y);
			graphics.lineStyle(20, 0x00ff00, 0, true);
			graphics.moveTo(spot1.x, spot1.y);
			graphics.lineTo(spot2.x, spot2.y);
		}
		
		/**
		 * Pour ouvrir le menu permettant de choisir le trajet.
		 */
		private function _onClick(event:MouseEvent):void {
			_trc("ON VA OUVRIR LE CHOIX DE TRAJET {"+event.localX+" ; "+event.localY+"}");
			event.stopPropagation();
			
			var mapEvent	:MapTravelEvent = new MapTravelEvent(MapTravelEvent.SEGMENT_SELECTED, true);
			mapEvent.x = event.localX;
			mapEvent.y = event.localY;
			dispatchEvent(mapEvent);
		}
	}
}