package  GameObjects{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;	
	
	public class Background extends Sprite {
		private var sheetBMD:BitmapData;		
		private var pos:Point = new Point();		
		
		public function Background() {
			this.sheetBMD = Res.sheet;
			
			var bitmap:Bitmap = new Bitmap();

			bitmap.bitmapData = Res.background;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;
			
			addChild(bitmap);
		}
	}	
}
