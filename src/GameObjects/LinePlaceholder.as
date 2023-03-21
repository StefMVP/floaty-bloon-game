package GameObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class LinePlaceholder extends Sprite
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
		
		private var passedPlayer:Boolean = false;
		private var MainClass:BalloonGame;
		
		public function LinePlaceholder(spawnY:int = 0, player:Player = null, main:BalloonGame = null)
		{
			//Used to create a null bird to get the width/height of a bird
			if (spawnY == 0 || player == null)
			{
				return;
			}
			x = BalloonGame.gameStageWidth/2;
			y = spawnY;
			this.player = player;
			MainClass = main;
			ySpeed += BalloonGame.ySpeedDifficultyAdd;
		}
		
		public function loop():void
		{
			
			
			if (stageWidth == 0 && stageHeight == 0)
			{
				stageWidth = BalloonGame.gameStageWidth;
				stageHeight = BalloonGame.gameStageHeight;
			}
			
			var distanceFromPlayer:Number = Math.abs(y - player.y);
			if (distanceFromPlayer < ySpeed && passedPlayer == false)
			{
				passedPlayer = true;
				MainClass.playerCrossedBird();
			}

			//Destoy object if off the screen
			if (checkIfOffScreen() == true)
			{
				removeEventListener(Event.ENTER_FRAME, loop);
				destroy();
			}	
			y += ySpeed;			
		}
		
		public function endGame():void
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
			{
				parent.removeChild(this);
			}
			BalloonGame.gameObjectArrayList.remove(this);
		}
	}
}
