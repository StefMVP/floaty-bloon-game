package GameObjects {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class CloudsFront extends Sprite {	
				
		private var sheetBMD:BitmapData;
		private var pos:Point = new Point();
		private var cloudSpeed:Number = 7*BalloonGame.globalScaleX;
		
		public function CloudsFront(skyX:int, skyY:int) {			
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmap.bitmapData = Res.cloudsFront;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
			x = skyX;
			y = skyY;
		}
		
		public function loop():void
		{			
			y += cloudSpeed;
			if (y - (height / 2) > BalloonGame.gameStageHeight)
			{
				y=BalloonGame.gameStageHeight - height*1.5;
			}
		}
		
		public function endGame():void
		{
			destroy();			
		}

		public function destroy():void
		{
			if(parent) parent.removeChild(this);
			BalloonGame.gameObjectArrayList.remove(this);
		}
	}	
}
