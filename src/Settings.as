package {
	/**
	 * @author csablons
	 */
	public class Settings {
		public static const VERSION	:String = "2.4.0";
		
		public static const DUREE_BLOCAGE	:uint = 200;	// Durée en millisecondes durant laquelle on bloque le clic
		//public static const SEUIL_MOUVEMENT	:uint = 100;	// Durée en millisecondes durant à partir de laquelle on considère qu'il y a eu mouvement
		
		// 500 miles = 804,67 km
		public static const PRECISION		:uint = 10;		// Interval de px pour lequel on teste le terrain
		public static const MILES_KM		:Number = 1.609;	// Converti un mile en kilomètre
		public static const PX_MILES		:Number = 1.84;	// Converti un pixel en mile
		public static const PX_KM			:Number = PX_MILES*MILES_KM;	// Converti un pixel en kilomètre
		public static const HEURE_JOUR		:Number = 8;	// Nombre d'heures par jour
		public static const GROSSE_MACHINE	:Number = 3;	// Coefficient d'efficacité surune journée
		
		public static const KM_HEURE_PIETON		:Number = 6;	// Km parcouru par un piéton par heure
		public static const KM_HEURE_CHEVAL		:Number = 10;	// Km parcouru par un cheval par heure
		public static const KM_HEURE_DILIGENCE	:Number = 15;	// Km parcouru par un diligence par heure
		public static const KM_HEURE_TRAIN		:Number = 40;	// Km parcouru par un train par heure
		public static const KM_HEURE_BATEAU		:Number = 15;	// Km parcouru par un bateau par heure
		public static const KM_HEURE_ZEPPELIN	:Number = 20;	// Km parcouru par un zeppelin par heure
		public static const KM_HEURE_TELEGRAMME	:Number = 48;	// Km parcouru par un télégramme par heure
		
		// Km parcouru par un piéton par jour
		public static function get KM_JOUR_PIETON():Number {
			return KM_HEURE_PIETON*HEURE_JOUR;
		}
		// Km parcouru par un cheval par jour
		public static function get KM_JOUR_CHEVAL():Number {
			return KM_HEURE_CHEVAL*HEURE_JOUR;
		}
		// Km parcouru par une diligence par jour
		public static function get KM_JOUR_DILIGENCE():Number {
			return KM_HEURE_DILIGENCE*HEURE_JOUR;
		}
		// Km parcouru par un train par jour
		public static function get KM_JOUR_TRAIN():Number {
			return KM_HEURE_TRAIN*HEURE_JOUR*GROSSE_MACHINE;
		}
		// Km parcouru par un bateau par jour
		public static function get KM_JOUR_BATEAU():Number {
			return KM_HEURE_BATEAU*HEURE_JOUR*GROSSE_MACHINE;
		}
		// Km parcouru par un zeppelin par jour
		public static function get KM_JOUR_ZEPPELIN():Number {
			return KM_HEURE_ZEPPELIN*HEURE_JOUR*GROSSE_MACHINE;
		}
		// Km parcouru par un télégramme par jour
		public static function get KM_JOUR_TELEGRAMME():Number {
			return KM_HEURE_TELEGRAMME*24;
		}
	}
}