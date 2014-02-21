package layer {
	import fl.motion.MatrixTransformer;

	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * @author csablons
	 */
	public class LayerContainer extends Sprite {
		
		// Données
		private var _idTimeout		:uint;
		private var _prevLocalX		:Number;
		private var _prevLocalY		:Number;
		private const _scaleMax		:Number = 5;
		private var _scaleMin		:Number = 1;		// Sera recalculé une fois le conteneur de calques prêt.
		private var _moved			:Boolean = false;	// true si on a bougé récemment
		private var _time			:Number;			// Pour connaître le temps entre le MouseDown et le MouseUp
		
		// Affichage
		public var relief			:ReliefAsset;
		public var map					:MapAsset;
		
		
		/**
		 * Constructeur
		 */
		public function LayerContainer() {
			map = new MapAsset();
			map.mouseEnabled = false;
			addChild(map);
			
			relief = new ReliefAsset();
			relief.width = map.width;
			relief.height = map.height;
			relief.visible = false;
			addChild(relief);
			
			addEventListener(MapTravelEvent.SPOT_GRABBED, _onSpotGrabbed);
			addEventListener(MapTravelEvent.SPOT_RELEASED, _onSpotReleased);
			
			_onContainerReady();
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("layer.LayerContainer : "+arguments);
		}

		/**
		 * Lorsque le conteneur de calques est prêt on détermine le scale minimal.
		 */
		private function _onContainerReady():void {
			_scaleMin = Math.min(Screen.mainScreen.bounds.width/width, Screen.mainScreen.bounds.height/height);
		}
		
		/**
		 * Pour initialiser les écouteurs.
		 */
		public function startListening():void {
			addEventListener(MouseEvent.CLICK, _onMapTap);
			addEventListener(MouseEvent.DOUBLE_CLICK, _onMapDoubleTap);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			addEventListener(TransformGestureEvent.GESTURE_ZOOM, _onZoom);
		}
		
		/**
		 * Pour initialiser les écouteurs.
		 */
		public function stopListening():void {
			removeEventListener(MouseEvent.CLICK, _onMapTap);
			removeEventListener(MouseEvent.DOUBLE_CLICK, _onMapDoubleTap);
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			removeEventListener(TransformGestureEvent.GESTURE_ZOOM, _onZoom);
		}
		
		//     ################################################################
		//  ###### INTERACTIONS
		// ####################################################################
		
		/**
		 * Lorsqu'on commence à déplacer un point de la carte on arrête d'écouter les mouvements de la carte.
		 */
		protected function _onSpotGrabbed(event:MouseEvent):void {
			_trc("### ### ### _onSpotGrabbed(event)");
			stopListening();
		}
		
		/**
		 * Lorsqu'on commence à déplacer un point de la carte on arrête d'écouter les mouvements de la carte.
		 */
		protected function _onSpotReleased(event:MouseEvent):void {
			_trc("### ### ### _onSpotReleased(event)");
			startListening();
			_lock();
		}
		
		/**
		 * On place un point sur la carte.
		 */
		protected function _onMapTap(event:MouseEvent):void {
//			_trc("### ### ### _onMapTap(event)");
			
			dispatchEvent(new MapTravelEvent(MapTravelEvent.ON_MAP_TAP));
		}
		
		/**
		 * On efface le tracé.
		 */
		protected function _onMapDoubleTap(event:MouseEvent):void {
//			_trc("### ### ### _onMapDoubleTap(event)");
			
			dispatchEvent(new MapTravelEvent(MapTravelEvent.ON_MAP_DOUBLE_TAP));
			_lock();
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseDown(event:MouseEvent):void {
			_trc("### ### ### _onMouseDown(event)");
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_prevLocalX = event.localX;
			_prevLocalY = event.localY;
			_time = getTimer();
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onMouseMove(event:MouseEvent):void {
//			_trc("### ### ### _onMouseMove(event)");
			
			var tOffsetX	:Number = event.localX - _prevLocalX;
			var tOffsetY	:Number = event.localY - _prevLocalY;
			
			x += tOffsetX;
			y += tOffsetY;
			
			_prevLocalX = event.localX - tOffsetX;
			_prevLocalY = event.localY - tOffsetY;
			
			_moved = true;
			
			_checkBounds();
		}
		
		/**
		 * Pour faire glisser la carte.
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
				
				_checkBounds();
				
				if (getTimer() - _time > Settings.DUREE_BLOCAGE) {
					_lock();
				}
				_moved = false;
			}

			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}
		
		/**
		 * Pour faire glisser la carte.
		 */
		private function _onZoom(event:TransformGestureEvent):void {
//			_trc("### ### ### _onZoom(event)");
			if (event.phase == GesturePhase.BEGIN) {
				removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
				removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				removeEventListener(MouseEvent.CLICK, _onMapTap);
				removeEventListener(MouseEvent.DOUBLE_CLICK, _onMapDoubleTap);
			}
			
			var locX			:Number = event.localX;
			var locY			:Number = event.localY;
			var stX				:Number = event.stageX;
			var stY				:Number = event.stageY;
			var prevScale		:Number = scaleX;	// scaleX et scaleY sont toujours identiques
			var mat				:Matrix;
			var externalPoint	:Point = new Point(stX, stY);
			var internalPoint	:Point = new Point(locX, locY);
			
			var nZoom	:Number = (event.scaleX + event.scaleY)/2;
			
			var nScale	:Number = prevScale * nZoom;
			nScale = Math.min(nScale, _scaleMax);
			nScale = Math.max(nScale, _scaleMin);
			scaleX = scaleY = nScale;
			
			mat = transform.matrix.clone();
			MatrixTransformer.matchInternalPointWithExternal(mat, internalPoint, externalPoint);
			transform.matrix = mat;

			_checkBounds();
			
			if (event.phase == GesturePhase.END) {
				_moved = false;
				addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
				addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
				addEventListener(MouseEvent.CLICK, _onMapTap);
				addEventListener(MouseEvent.DOUBLE_CLICK, _onMapDoubleTap);
				_lock();
			}
		}
		
		/**
		 * Pour vérifier que la carte ne sort pas du cadre.
		 */
		private function _checkBounds():void {
			if (width > stage.stageWidth) {
				if (x > 0) {
					x = 0;
				}
				
				if (x < stage.stageWidth - width) {
					x = stage.stageWidth - width;
				}
			}
			else {
				x = Math.round((stage.stageWidth - width)/2);
			}
			
			if (height > stage.stageHeight) {
				if (y > 0) {
					y = 0;
				}
				
				if (y < stage.stageHeight - height) {
					y = stage.stageHeight - height;
				}
			}
			else {
				y = Math.round((stage.stageHeight - height)/2);
			}
		}
		
		/**
		 * Empêche de cliquer sur la carte.
		 * Utile car souvent après un double-clic, un spot apparait.
		 */
		private function _lock():void {
			_idTimeout = setTimeout(_unlock, Settings.DUREE_BLOCAGE);
			removeEventListener(MouseEvent.CLICK, _onMapTap);
		}
		
		/**
		 * Débloque la carte.
		 */
		private function _unlock():void {
			clearTimeout(_idTimeout);
			addEventListener(MouseEvent.CLICK, _onMapTap);
		}

		// ####################################################################
		//  ###### INTERACTIONS
		//     ################################################################
	}
}