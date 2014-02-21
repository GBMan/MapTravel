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
		
//		public var var1	:uint;
//		public var var2	:uint;
		
		public function MapTravelEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone() : Event {
			var e : MapTravelEvent = new MapTravelEvent(type, bubbles, cancelable);
//			e.var1 = var1;
//			e.var2 = var2;
			return e;
		}
	}
}