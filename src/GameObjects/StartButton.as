package GameObjects  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class StartButton extends Sprite 
	{		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		
		public function StartButton() 
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.StartButton.width, Res.StartButton.height);
			bitmapContainer.copyPixels(sheetBMD, Res.StartButton, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	
		public function render():void
		{
			pos.x = x - Res.StartButton.width / 2;
			pos.y = y - Res.StartButton.height / 2;			
		}	
	}	
}
