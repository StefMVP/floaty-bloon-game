package GameObjects  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PlayAgainButton extends Sprite 
	{		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		private var bitmap:Bitmap;
		
		public function PlayAgainButton() 
		{
			this.sheetBMD = Res.sheet;
			
			bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.PlayAgainButton.width, Res.PlayAgainButton.height);
			bitmapContainer.copyPixels(sheetBMD, Res.PlayAgainButton, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	
		public function render():void
		{
			pos.x = x - Res.PlayAgainButton.width / 2;
			pos.y = y - Res.PlayAgainButton.height / 2;			
		}	
		
		public function pushed():void
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.PlayAgainButtonPushed.width, Res.PlayAgainButtonPushed.height);
			bitmapContainer.copyPixels(sheetBMD, Res.PlayAgainButtonPushed, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
		public function unpushed():void
		{
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();
			bitmapContainer = new BitmapData(Res.PlayAgainButton.width, Res.PlayAgainButton.height);
			bitmapContainer.copyPixels(sheetBMD, Res.PlayAgainButton, pos);
			bitmap.bitmapData = bitmapContainer;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	}	
}
