package layer{
	/**
	 * @author csablons
	 */
	public class Terrain {
		public var color	:uint;
		public var coef		:Number;
		
		/**
		 * Constructeur
		 * @param color Couleur du terrain
		 * @param coef	Coefficient de difficulté du terrain
		 */
		public function Terrain(color:uint, coef:Number) {
			this.color = color;
			this.coef = coef;
	}
	}
}