package GameObjects {	
	import flash.geom.Rectangle;
	
	public class NormalBird extends Bird {
		private var xSpeedConst:Number = 3.50;
		private var upImage:Rectangle = Res.OneGreenUp;
		private var downImage:Rectangle = Res.OneGreenDown;
		
		public function NormalBird(dir:String=null, spawnX:int = 0, spawnY:int=0, player:Player=null)
		{
			super(dir, spawnX, spawnY, player, upImage, downImage);
			super.setXSpeed(xSpeedConst);		
		}
	}	
}
