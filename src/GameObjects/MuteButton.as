package GameObjects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class MuteButton extends Sprite
	{
		private var bitmap = new Bitmap();
		
		public function MuteButton() 
		{
			bitmap.bitmapData = Res.muteIcon;			
			bitmap.x -= bitmap.width/2;
			bitmap.y -= bitmap.height/2;

			addChild(bitmap);
		}
		
		public function setIcon(icon:String):void
		{
			removeChild(bitmap);
			
			if(icon == "Mute")
			{
				bitmap.bitmapData = Res.muteIcon;			
			}
			else
			{			
				bitmap.bitmapData = Res.speakerIcon;	
			}

			addChild(bitmap);
		}
	}
}