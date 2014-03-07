package {
	import interface.pannel.Pannel;
	import mx.core.ButtonAsset;
	import indication.Indication;

	import layer.LayerContainer;

	import result.Result;

	import way.SpotsList;

	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageAspectRatio;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.StageOrientationEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	public class MapFullFDT extends Sprite {
		
		// Données
		private var _bTravelStarted	:Boolean = false;
		private var _spotsList		:SpotsList;
		
		// Affichage
		private var _layerContainer		:LayerContainer;
		public var blocIndication		:Indication;
		public var blocResult			:Result;
		
		
		/**
		 * Constructeur
		 */
		public function MapFullFDT() {
			stage.color = 0;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
			
			_layerContainer = new LayerContainer();
//			_layerContainer.mouseChildren = false;
			addChild(_layerContainer);
			_layerContainer.addEventListener(MapTravelEvent.ON_MAP_TAP, _onMapTap);
			_layerContainer.addEventListener(MapTravelEvent.ON_MAP_DOUBLE_TAP, _onMapDoubleTap);
			_layerContainer.addEventListener(MapTravelEvent.SEGMENT_SELECTED, _onSegmentSelected);
			
			_spotsList = new SpotsList(_layerContainer, _layerContainer.relief);
			
			blocIndication = new Indication();
			blocIndication.tf.text = Translations.START;
			addChild(blocIndication.asset);
			
			blocResult = new Result();
			blocResult.visible = false;
			addChild(blocResult.asset);
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
//			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, checkKeypress);
//			_trc("NativeApplication.supportsMenu = "+NativeApplication.supportsMenu);
//			_trc("NativeApplication.nativeApplication.menu = "+NativeApplication.nativeApplication.menu);
//			var m	:NativeMenu = new NativeMenu();
//			m.addItem(new NativeMenuItem("Jambon"));
//			m.addItem(new NativeMenuItem("Beurre", true));
//			m.addItem(new NativeMenuItem("Coca"));
//			m.addItem(new NativeMenuItem("Lait"));
//			m.addItem(new NativeMenuItem("Eau"));
//			NativeApplication.nativeApplication.menu = m;
//			_trc("NativeApplication.nativeApplication.openedWindows = "+NativeApplication.nativeApplication.openedWindows);
//			_trc("NativeApplication.nativeApplication.publisherID = "+NativeApplication.nativeApplication.publisherID);
		}
		
		/**
		 * 
		 */
		private function _onSegmentSelected(event:MapTravelEvent):void {
			_trc("_onSegmentSelected(event)");
			
			var pan	:Pannel = new Pannel();
			
			addChild(pan);
			var spr	:Sprite;
			
			spr = new Sprite();
			spr.graphics.beginFill(0xff0000);
			spr.graphics.drawRect(event.x*_layerContainer.scaleX + _layerContainer.x, event.y*_layerContainer.scaleX + _layerContainer.y, 300, 300);
			spr.graphics.endFill();
			addChild(spr);
		}
		
		public function checkKeypress(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.BACK:
					event.preventDefault();
					trace("Back key is pressed.");
					break;
				case Keyboard.MENU:
					trace("Menu key is pressed.");
					break;
				case Keyboard.SEARCH:
					trace("Search key is pressed.");
					break;
			}
		}
		
		/**
		 * Lorsque l'orientation change
		 */
		private function _onOrientationChange(event:StageOrientationEvent):void {
			_trc("_onOrientationChange(event)");
			_trc("stage.orientation = "+stage.orientation);
			_trc("stage.width = "+stage.width);
			_trc("stage.height = "+stage.height);
			_trc("stage.stageWidth = "+stage.stageWidth);
			_trc("stage.stageHeight = "+stage.stageHeight);
			_trc("Screen.mainScreen.bounds = "+Screen.mainScreen.bounds);
			_draw();
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("Map : "+arguments);
		}
		
		/**
		 * Lorsque la zone d'affichage est affichée.
		 */
		protected function _onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
//			_trc("stage.orientation = "+stage.orientation);
//			_trc("Screen.mainScreen.bounds = "+Screen.mainScreen.bounds);
//			_trc("stage.stageWidth = "+stage.stageWidth);
//			_trc("stage.stageHeight = "+stage.stageHeight);
			
//			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, _onOrientationChange);
			
			_layerContainer.startListening();
			
			_draw();
		}
		/**
		 * On place un point sur la carte.
		 */
		protected function _onMapTap(event:MapTravelEvent):void {
//			_trc("### ### ### _onMapTap(event)");
			
			if (_bTravelStarted) {
				_spotsList.addSpot();
				
				_refreshResult();
				blocResult.visible = true;
			}
			else {
				blocIndication.tf.text = Translations.CONTINUE;
				_spotsList.addSpot();
				_bTravelStarted = true;
			}
		}
		
		/**
		 * Lorsqu'on double-clique sur la map on efface.
		 */
		protected function _onMapDoubleTap(event:MapTravelEvent):void {
//			_trc("### ### ### _onMapDoubleTap(event)");
			
			if (_bTravelStarted) {
				_clean();
			}
		}
		
		/**
		 * Supprime les points et le tracé. Enlève le panneau de résultats. Met le texte par défaut.
		 */
		protected function _clean():void {
			blocResult.tf.text = "";
			_spotsList.clean();

			blocIndication.tf.text = Translations.START;
			blocResult.visible = false;
			_bTravelStarted = false;
		}
				
		/**
		 * Repositionne les éléments.
		 */
		private function _draw():void {
			blocIndication.width = Screen.mainScreen.bounds.width;
			blocIndication.y = Math.round(Screen.mainScreen.bounds.height - blocIndication.height);
		}
		
		/**
		 * Affiche les résultats
		 */
		protected function _refreshResult():void {
			var km		:Number = _spotsList.length()*Settings.PX_KM;
			var kmDiff	:Number = _spotsList.lengthDiff()*Settings.PX_KM;
			
			var tf	:TextField = blocResult.tf;
			tf.text = "";
			tf.text = _spotsList.length()+"px\n";
			tf.appendText(Math.round(km*100)/100+" "+Translations.DISTANCE+"\n");
			tf.appendText(Math.round(kmDiff*100)/100+" "+Translations.DISTANCE_FELT+"\n");
			tf.appendText(Translations.WALKER+" : "+Math.round(kmDiff/Settings.KM_JOUR_PIETON)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.HORSE+" : "+Math.round(kmDiff/Settings.KM_JOUR_CHEVAL)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.DILIGENCE+" : "+Math.round(kmDiff/Settings.KM_JOUR_DILIGENCE)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.TRAIN+" : "+Math.round(km/Settings.KM_JOUR_TRAIN)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.BOAT+" : "+Math.round(km/Settings.KM_JOUR_BATEAU)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.ZEPPELIN+" : "+Math.round(km/Settings.KM_JOUR_ZEPPELIN)+" "+Translations.DAYS+"\n");
			tf.appendText(Translations.TELEGRAM+" : "+Math.round(km/Settings.KM_JOUR_TELEGRAMME)+" "+Translations.DAYS+"\n");
		}
	}
}