package GameObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Leaderboard extends Sprite
	{
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		public function Leaderboard()
		{
	
					
			var bitmap:Bitmap = new Bitmap();
		
			bitmap.bitmapData = Res.leaderBoard;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
				
			addChild(bitmap);
		}
			
		public function render():void
		{
			pos.x = x - Res.RateButton.width / 2;
			pos.y = y - Res.RateButton.height / 2;			
		}	
		
		public function pushed():void
		{
		
			
			var bitmap:Bitmap = new Bitmap();
			
			bitmap.bitmapData = Res.leaderBoardPushed;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
		public function unpushed():void
		{
			
			
			var bitmap:Bitmap = new Bitmap();
		
			bitmap.bitmapData = Res.leaderBoard;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	}
	
}