package GameObjects {	
	import flash.geom.Rectangle;
	
	public class FastBird extends Bird {
		private var xSpeedConst:Number = 5.50;
		private var upImage:Rectangle = Res.OneYellowUp;
		private var downImage:Rectangle = Res.OneYellowDown;
		
		public function FastBird(dir:String=null, spawnX:int = 0, spawnY:int=0, player:Player=null)
		{
			super(dir, spawnX, spawnY, player, upImage, downImage);
			super.setXSpeed(xSpeedConst);		
		}			
	}	
}
