package GameObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Bird extends Sprite
	{
		private var xSpeed:Number;
		private var ySpeed:Number = BalloonGame.initObjectYSpeed;
		private var birdDir:String;
		private var player:Player;
		private var _root:Object;
		private var stageWidth:int = 0;
		private var stageHeight:int = 0;
		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		private var bitmap:Bitmap = new Bitmap();
		private var upImage:Rectangle = new Rectangle();
		private var downImage:Rectangle = new Rectangle();
		private var randNum:int = Math.floor(Math.random()*15 + 20);
		private var wingsAreUp:Boolean = true;
		//private var randNum2:int = Math.floor(Math.random()*10 + 60);
		
		public function Bird(dir:String = null, spawnX:int = 0, spawnY:int = 0, player:Player = null, UpImage:Rectangle = null, DownImage:Rectangle = null, frameCount:int = 0)
		{
			//Used to create a null bird to get the width/height of a bird
			if (dir == null || spawnX == 0 || spawnY == 0 || player == null)
			{
				return;
			}

			x = spawnX;
			y = spawnY;
			ySpeed += BalloonGame.ySpeedDifficultyAdd;
			downImage = DownImage;
			upImage = UpImage;
			
			birdDir = dir;
			this.player = player;
			this.sheetBMD = Res.sheet;
			
			bitmapContainer = new BitmapData(UpImage.width, UpImage.height);
			bitmapContainer.copyPixels(sheetBMD, UpImage, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			bitmap.scaleX = bitmap.scaleY = BalloonGame.globalScaleX;
			addChild(bitmap);
			
		

		}
		
		public function loop():void
		{	
			if (upImage !=  null && downImage != null)
			{
				if (BalloonGame.frameCount % randNum == 0)
				{
					if (wingsAreUp == true)
					{
						y -= 4*BalloonGame.globalScaleX;			
						
						bitmapContainer = new BitmapData(downImage.width, downImage.height);
						bitmapContainer.copyPixels(sheetBMD, downImage, pos);
						bitmap.bitmapData = bitmapContainer;			
						//bitmap.scaleX = bitmap.scaleY = BalloonGame.globalScaleX;
						addChild(bitmap);
						wingsAreUp = false;
					}
					else
					{
						y += 4*BalloonGame.globalScaleX;
						
						bitmapContainer = new BitmapData(upImage.width, upImage.height);
						bitmapContainer.copyPixels(sheetBMD,upImage, pos);
						bitmap.bitmapData = bitmapContainer;			
						//bitmap.scaleX = bitmap.scaleY = BalloonGame.globalScaleX;
						addChild(bitmap);
						wingsAreUp = true;
					}				
				}	
			}	

			//Move left
			if (stageWidth == 0 && stageHeight == 0)
			{
				stageWidth = BalloonGame.gameStageWidth;
				stageHeight = BalloonGame.gameStageHeight;
			}
			if (birdDir == Dir.LEFT)
			{
				x -= xSpeed;
				y += ySpeed;
				scaleX = 1;
			}
			//Move right
			else if (birdDir == Dir.RIGHT)
			{
				x += xSpeed;
				y += ySpeed;
				scaleX = -1;
			}
			//Destoy bird object if bird is off the screen (Right)
			if (checkIfOffScreen() == true)
			{
				removeEventListener(Event.ENTER_FRAME, loop);
				destroy();
			}
		}
		
		/*private function endGameLoop(e:Event):void
		{
			var xSpeedEndGame:int = 12;
			//Move left
			if (stageWidth == 0 && stageHeight == 0)
			{
				stageWidth = BalloonGame.gameStageWidth;
				stageHeight = BalloonGame.gameStageHeight;
			}
			if (birdDir == Dir.LEFT)
			{
				x -= xSpeedEndGame;
				scaleX = 1;
			}
			//Move right
			else if (birdDir == Dir.RIGHT)
			{
				x += xSpeedEndGame;
				scaleX = -1;
			}
			//Destoy bird object if bird is off the screen
			if (checkIfOffScreen() == true)
			{
				removeEventListener(Event.ENTER_FRAME, endGameLoop);
				destroy();				
			}
		}*/
		
		private function checkIfOffScreen():Boolean
		{
			if (y > stageHeight)
			{
				return true;			
			}
			else
			{
				return false;
			}
		}		
		
		public function endGame():void
		{
			destroy();
		}
		
		public function destroy():void
		{
			if (BalloonGame.collisionList != null)
			{
				BalloonGame.collisionList.removeItem(this);
			}
			if (parent)
				parent.removeChild(this);
			BalloonGame.gameObjectArrayList.remove(this);
		}
		
		public function setXSpeed(xSpeed:Number):void
		{
			this.xSpeed = xSpeed*BalloonGame.globalScaleX;
		}
	}
}
