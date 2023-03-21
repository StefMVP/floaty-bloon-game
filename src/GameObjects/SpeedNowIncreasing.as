package GameObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class SpeedNowIncreasing extends Sprite
	{
		private var ySpeed:Number = 3.75*BalloonGame.globalScaleX;
		private var player:Player;
		private var _root:Object;
		private var stageWidth:int = 0;
		private var stageHeight:int = 0;
		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		private var bitmap:Bitmap = new Bitmap();
		

		public function SpeedNowIncreasing(spawnY:int = 0, spawnX:int = 0)
		{
			x = spawnX;
			y = spawnY;
			scaleX = BalloonGame.globalScaleX;
			scaleY = BalloonGame.globalScaleY;
			
			this.sheetBMD = Res.sheet;
			
			bitmapContainer = new BitmapData(Res.SpeedIncrease.width, Res.SpeedIncrease.height);
			bitmapContainer.copyPixels(sheetBMD, Res.SpeedIncrease, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;			
			addChild(bitmap);
			ySpeed += BalloonGame.ySpeedDifficultyAdd;			
			
			
		}
		
		public function loop():void
		{
			//Increase difficulty..
			ySpeed = BalloonGame.initObjectYSpeed + BalloonGame.ySpeedDifficultyAdd;
			
			if (stageWidth == 0 && stageHeight == 0)
			{
				stageWidth = BalloonGame.gameStageWidth;
				stageHeight = BalloonGame.gameStageHeight;
			}

			//Destoy object if off the screen
			if (checkIfOffScreen() == true)
			{
				destroy();
			}	
			y += ySpeed;			
		}
		
		public function endGame(isPause:Boolean):void
		{
			destroy();
		}	
	
		private function checkIfOffScreen():Boolean
		{
			if (y  > stageHeight)
			{
				return true;
			}			
			else
			{
				return false;
			}
		}
		
		public function destroy():void
		{			
			if (parent)
				parent.removeChild(this);
		}
		
	}
}
