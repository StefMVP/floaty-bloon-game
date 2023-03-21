package  GameObjects {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	public class Player extends Sprite {
		private var speed:Number = 0;
		private var constSpeed:Number = 1.25*BalloonGame.globalScaleX;
		private var maxSpeedConstant:Number = 12*BalloonGame.globalScaleX;
		private var friction:Number = .9;
		public var leftPressed:Boolean = false;
		public var rightPressed:Boolean = false;
		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		private var bitmap:Bitmap;
		private var endGameFrameCount:int = 0;
		private var curPlayerX:int;
		private var curPlayerY:int;
		
		public function Player(xLocation:int = 0, yLocation:int = 0)
		{		
			this.sheetBMD = Res.sheet;
			bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.Player.width, Res.Player.height);
			bitmapContainer.copyPixels(sheetBMD, Res.Player, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			addChild(bitmap);
			
			if (yLocation == 0 || xLocation == 0)
			{
				return;		
			}
			
			x = xLocation;
			y = yLocation;
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
			if(x + width/2 + BalloonGame.gameStageWidth/80 > BalloonGame.gameStageWidth && speed > 0)
			{
				speed = 0;
				rightPressed = false;
			}			
			//Left Wall
			else if (x - width/2 - BalloonGame.gameStageWidth/80 < 0 && speed < 0)
			{
				speed = 0;
				leftPressed = false;
			}			
			x += speed;
		}
		
		public function endGameLoop():void
		{

			if(endGameFrameCount == 2)
			{
				bitmapContainer = new BitmapData(Res.Pop1.width, Res.Pop1.height);
				bitmapContainer.copyPixels(sheetBMD,Res.Pop1, pos);				
				bitmap.bitmapData = bitmapContainer;	
				bitmap.x -= bitmap.width/4;
				bitmap.y -= bitmap.height/4;
				addChild(bitmap);
			}
			else if (endGameFrameCount == 3)
			{
				if(BalloonGame.isMuted.data['isMuted'] == "False")
				{
					Res.bubblePop.play();
				}
			}
			else if (endGameFrameCount == 4)
			{
				bitmapContainer = new BitmapData(Res.Pop2.width, Res.Pop2.height);
				bitmapContainer.copyPixels(sheetBMD,Res.Pop2, pos);
				bitmap.bitmapData = bitmapContainer;
				bitmap.x -= bitmap.width/4;
				bitmap.y -= bitmap.height/4;
				addChild(bitmap);			
			}
			else if (endGameFrameCount == 8)
			{						
				removeChild(bitmap);			
			}
			else if( endGameFrameCount > 8)
			{
				removeEventListener(Event.ENTER_FRAME, endGameLoop);
			}
			endGameFrameCount++;
		}
		public function incMaxSpeed():void
		{
			this.maxSpeedConstant += 2*BalloonGame.globalScaleX;
			this.constSpeed += .1*BalloonGame.globalScaleX;
		}		
	}
}
