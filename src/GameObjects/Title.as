package GameObjects  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Title extends Sprite 
	{		
		private var sheetBMD:BitmapData;
		private var bitmapContainer:BitmapData;
		private var pos:Point = new Point();
		
		public function Title() 
		{
			var bitmap:Bitmap = new Bitmap();
		
			bitmap.bitmapData = Res.title;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	
		public function render():void
		{		
		}	
	}	
}
