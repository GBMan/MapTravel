package {
	import flash.events.Event;

	/**
	 * @author csablons
	 */
	public class MapTravelEvent extends Event {
		
		public static const ON_MAP_TAP			:String = "onMapTap";
		public static const ON_MAP_DOUBLE_TAP	:String = "onMapDoubleTap";
		public static const SPOT_GRABBED		:String = "onSpotGrabbed";
		public static const SPOT_RELEASED		:String = "onSpotReleased";
		public static const SEGMENT_SELECTED	:String = "onSegmentSelected";
		
		public var x	:Number;
		public var y	:Number;
		
		public function MapTravelEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event {
			var e : MapTravelEvent = new MapTravelEvent(type, bubbles, cancelable);
			e.x = x;
			e.y = y;
			return e;
		}
	}
}