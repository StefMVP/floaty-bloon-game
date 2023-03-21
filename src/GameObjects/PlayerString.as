package  GameObjects {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class PlayerString extends Sprite {
		private var speed:Number = 0;
		private var constSpeed:Number = 1.25*BalloonGame.globalScaleX;
		private var maxSpeedConstant:Number = 12*BalloonGame.globalScaleX;
		private var friction:Number = .9;
		public var leftPressed:Boolean = false;
		public var rightPressed:Boolean = false;
		private var playerWidth:int;
		private var playerHeight:int;
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		private var bitmap:Bitmap;
		private var endGameFrameCount:int = 0;
		private var localFrameCount = 0;
		private var isWaveOne:Boolean = true;
		private var leftString:Boolean = true;
		
		public function PlayerString(xLocation:int = 0, yLocation:int = 0, PlayerWidth:int=0, PlayerHeight:int=0)
		{		
			this.sheetBMD = Res.sheet;
			bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.StringWaveTwo.width, Res.StringWaveTwo.height);
			bitmapContainer.copyPixels(sheetBMD, Res.StringWaveTwo, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
			
			if (yLocation == 0 || xLocation == 0)
			{
				return;		
			}
			playerWidth = PlayerWidth;
			playerHeight = PlayerHeight;			
			scaleX = scaleY = BalloonGame.globalScaleX;
			x = xLocation;
			y = yLocation + this.height/2;
		}
		public function movePlayer(moveDirection):void
		{
			if (moveDirection == Dir.RIGHT)
			{
				rightPressed = true;
			}
				
			else if (moveDirection == Dir.LEFT)
			{
				leftPressed = true;
			}	
		}
		
		public function stopPlayer(dir:String):void
		{
			if(dir == Dir.LEFT)
			{	
				leftPressed = false;			
			}	
			else if(dir == Dir.RIGHT)
			{	
				rightPressed = false;	
			}
		}
		public function loop():void
		{		
			
			if(localFrameCount % 15 == 0)
			{
				if(leftString)
				{
					this.scaleX *= -1;
					leftString = false;
				}
				else
				{
					this.scaleX *= -1;
					leftString = true;	
				}
			}
			
			if(leftPressed)
			{
				speed -= constSpeed;
			} 			
			if(rightPressed)
			{
				speed += constSpeed;
			}
			
			speed *= friction;
			
			if(speed > maxSpeedConstant)
			{ 
				speed = maxSpeedConstant;
			}			
			else if(speed < (maxSpeedConstant * -1))
			{
				speed = (maxSpeedConstant * -1);
			}
			
			//Right wall
			if(x + playerWidth/2 + stage.stageWidth/80 > stage.stageWidth && speed > 0)
			{
				speed = 0;
				rightPressed = false;
			}			
			//Left Wall
			else if (x - playerWidth/2 - stage.stageWidth/80 < 0 && speed < 0)
			{
				speed = 0;
				leftPressed = false;
			}	
			x += speed;
			localFrameCount++;
		}
				
		public function endGame():void
		{
			if (parent)
				parent.removeChild(this);
			BalloonGame.gameObjectArrayList.remove(this);
		}
		
		public function incMaxSpeed():void
		{
			this.maxSpeedConstant += 2*BalloonGame.globalScaleX;
			this.constSpeed += .1*BalloonGame.globalScaleX;
		}
	}
}
