package GameObjects  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class ScoreScreen extends Sprite 
	{		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		
		public function ScoreScreen() 
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.ScoreScreen.width, Res.ScoreScreen.height);
			bitmapContainer.copyPixels(sheetBMD, Res.ScoreScreen, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	
		public function render():void
		{
			pos.x = x - Res.ScoreScreen.width / 2;
			pos.y = y - Res.ScoreScreen.height / 2;			
		}	
	}	
}
