package way{
	import layer.Terrain;
	import layer.Terrains;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * @author csablons
	 */
	public class SpotsList {
		private var _spots		:Vector.<Spot>;
		private var _holder		:Sprite;
		private var _relief		:Sprite;
		private var _bmpData	:BitmapData;
		
		/**
		 * Constructeur
		 * @param holder Conteneur des spots.
		 */
		public function SpotsList(holder:Sprite, relief:Sprite) {
			_holder = holder;
			_relief = relief;
			
			_bmpData = new BitmapData(_relief.width, _relief.height);
			_bmpData.draw(_relief);
			
//			_holder.getChildAt(0).alpha = 0;
			
			_spots = new Vector.<Spot>();
		}
		
		/**
		 * Affiche une trace avec le chemin de la class.
		 */
		private function _trc(...arguments):void {
			trace("way.SpotsList : "+arguments);
		}
		
		/**
		 * Ajoute un point aux coordonnées indiquées
		 */
		public function clean():void {
			while (_holder.numChildren > 1) {
				_holder.removeChildAt(1);
			}
			if (_spots) {
				// TODO Boucle où on enlève les écouteurs.
				_spots = null;
			}
			_spots = new Vector.<Spot>();
		}
		
		/**
		 * Ajoute un point aux coordonnées indiquées
		 */
		public function addSpot():void {
			var spot	:Spot = new Spot();
			spot.x = _holder.mouseX;
			spot.y = _holder.mouseY;
//			spot.label = "Bisou_"+_spots.length;
			_spots.push(spot);
			_holder.addChild(spot.asset);
			_drawLine();
		}
		
		/**
		 * Ajoute un point aux coordonnées indiquées
		 */
		private function _drawLine():void {
			var l	:uint = _spots.length;
			
			if (l > 1) {
				var segment	:Segment = new Segment(_spots[l-2], _spots[l-1]);
				_holder.addChild(segment);
				_spots[l-2].segment2 = segment;
				_spots[l-1].segment1 = segment;
			}
		}
		
		/**
		 * Calcule la longueur d'un trajet en pixel.
		 */
		public function length():Number {
			var l		:uint = _spots.length;
			var nPx		:Number = 0;
			var nDiff	:Number = 0;
			var i		:uint = 0;
			var prevSpot	:Spot = _spots[0];
			var spot		:Spot;
			
			for (i=1; i<l; i++) {
				spot = _spots[i];
				nPx += _segmentLength(prevSpot, spot);
				nDiff += _segmentLengthDiff(prevSpot, spot, nPx);
				prevSpot = spot;
			}
			
			return Math.round(nPx*100)/100;
		}
		
		/**
		 * Retourne la longueur d'un segment
		 */
		private function _segmentLength(spot1:Spot, spot2:Spot):Number {
			var difX	:int = spot1.x - spot2.x;
			var difY	:int = spot1.y - spot2.y;
			
			return Math.sqrt(difX*difX + difY*difY);
		}
		
		/**
		 * Calcule la longueur d'un trajet en tenant compte de la difficulté du terrain
		 */
		public function lengthDiff():Number {
			var l		:uint = _spots.length;
			var nDiff	:Number = 0;
			var i		:uint = 0;
			var prevSpot	:Spot = _spots[0];
			var spot		:Spot;
			
			for (i=1; i<l; i++) {
				spot = _spots[i];
				nDiff += _segmentLengthDiff(prevSpot, spot);
				prevSpot = spot;
			}
			
			return Math.round(nDiff*100)/100;
		}
		
		/**
		 * Retourne la longueur d'un segment
		 */
		private function _segmentLengthDiff(spot1:Spot, spot2:Spot, segLength:Number=Number.NaN):Number {
			if (isNaN(segLength)) {
				segLength = _segmentLength(spot1, spot2);
			}
			
			var i	:uint;	// Interval
			var nbStep	:uint = Math.max(segLength/Settings.PRECISION, 1);
			var nDiff	:Number = 0;
			var col	:uint;
			var ter	:Terrain;
			var x	:Number;
			var y	:Number;
			var a	:Number = (spot1.y - spot2.y)/(spot1.x - spot2.x);
			var b	:Number = spot1.y - spot1.x*a;
			var stepX	:Number = (spot2.x - spot1.x)/nbStep;
			
			for (i=0; i<nbStep; i++) {
				x = spot1.x + stepX*i;
				y = a*x + b;
				col = _bmpData.getPixel(x, y);
				ter = Terrains.getTerrain(col);
				nDiff += Settings.PRECISION*ter.coef;
			}
			
			// Pour compléter le dernier morceau de segment inférieur à la précision
			if (ter) {
				nDiff += (segLength - i*Settings.PRECISION)*ter.coef;
			}
			
			return nDiff;
		}
	}
}
