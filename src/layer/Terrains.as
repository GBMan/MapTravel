package layer{
	/**
	 * @author csablons
	 */
	public class Terrains {
		public static const EAU			:Terrain = new Terrain(0x0000ff, 1);
		public static const DESERT		:Terrain = new Terrain(0xffff00, 1.2);
		public static const FORET		:Terrain = new Terrain(0x00ff00, 1.1);
		public static const PLAINE		:Terrain = new Terrain(0xffffff, 1);
		public static const MONTAGNE	:Terrain = new Terrain(0xcccccc, 2);
		
		/**
		 * Retourne le terrain correspondant au code couleur indiqué.
		 * @param col	Code couleur demandé.
		 */
		public static function getTerrain(col:uint):Terrain {
			//TODO Boucle sur une liste des Terrains existants
			
			var t	:Terrain;
			
			switch (col) {
				case Terrains.MONTAGNE.color :
					t = Terrains.MONTAGNE;
					break;
					
				case Terrains.PLAINE.color :
				default :
					t = Terrains.PLAINE;
					break;
			}
			
			return t;
		}
	}
}
