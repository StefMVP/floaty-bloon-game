package GameObjects {	
	import flash.geom.Rectangle;
	
	public class SlowBird extends Bird {
		private var xSpeedConst:Number = 1.50;	
		private var upImage:Rectangle = Res.OnePurpleUp;
		private var downImage:Rectangle = Res.OnePurpleDown;
		
		public function SlowBird(dir:String=null, spawnX:int = 0, spawnY:int=0, player:Player=null)
		{
			super(dir, spawnX, spawnY, player, upImage, downImage);
			super.setXSpeed(xSpeedConst);		
		}
	}	
}
