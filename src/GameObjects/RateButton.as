package GameObjects  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class RateButton extends Sprite 
	{		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		
		public function RateButton() 
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.RateButton.width, Res.RateButton.height);
			bitmapContainer.copyPixels(sheetBMD, Res.RateButton, pos);
			bitmap.bitmapData = bitmapContainer;			
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
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.RatePushed.width, Res.RatePushed.height);
			bitmapContainer.copyPixels(sheetBMD, Res.RatePushed, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
		public function unpushed():void
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.RateButton.width, Res.RateButton.height);
			bitmapContainer.copyPixels(sheetBMD, Res.RateButton, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	}	
}
