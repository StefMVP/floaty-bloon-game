package GameObjects
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	
	public final class Res
	{
		[Embed(source="sprites.png")]
		public static var Sheet:Class;
		public static var sheet:BitmapData = new Sheet().bitmapData;
		
		public static var IconRounded:Rectangle = new Rectangle(878,409,57,58);
		public static var OneGreenDown:Rectangle = new Rectangle(961,525,55,39);
		public static var OneGreenUp:Rectangle = new Rectangle(878,469,55,43);
		public static var OnePurpleDown:Rectangle = new Rectangle(847,558,55,39);
		public static var OnePurpleUp:Rectangle = new Rectangle(847,514,55,42);
		public static var OneYellowDown:Rectangle = new Rectangle(904,525,55,39);
		public static var OneYellowUp:Rectangle = new Rectangle(935,481,55,42);
		public static var PauseButton:Rectangle = new Rectangle(972,2,49,55);
		public static var PlayAgainButton:Rectangle = new Rectangle(607,1049,223,178);
		public static var PlayAgainButtonPushed:Rectangle = new Rectangle(607,869,223,178);
		public static var Player:Rectangle = new Rectangle(937,409,56,70);
		//public static var PlayerString:Rectangle = new Rectangle(972,147,40,33);
		public static var Pop1:Rectangle = new Rectangle(878,271,130,136);
		public static var Pop2:Rectangle = new Rectangle(636,271,240,236);
		public static var RateButton:Rectangle = new Rectangle(607,689,223,178);
		public static var RatePushed:Rectangle = new Rectangle(622,509,223,178);
		public static var ResumeButton:Rectangle = new Rectangle(639,2,331,267);
		public static var ScoreScreen:Rectangle = new Rectangle(2,615,603,433);
		public static var SpeedIncrease:Rectangle = new Rectangle(2,2,635,175);
		public static var StartButton:Rectangle = new Rectangle(2,1050,474,107);
		public static var StringLeft:Rectangle = new Rectangle(972,103,40,42);
		public static var StringRight:Rectangle = new Rectangle(972,59,40,42);
		public static var StringWaveOne:Rectangle = new Rectangle(622,236,12,55);
		public static var StringWaveTwo:Rectangle = new Rectangle(622,179,12,55);
		
		
		[Embed(source="ScoreButton.png")]
		public static var LeaderBoard:Class
		public static var leaderBoard:BitmapData = new LeaderBoard().bitmapData;
		
		[Embed(source="ScoreButtonPushed.png")]
		public static var LeaderBoardPushed:Class
		public static var leaderBoardPushed:BitmapData = new LeaderBoardPushed().bitmapData;
		
		[Embed(source="Title.png")]
		public static var TitleImg:Class
		public static var title:BitmapData = new TitleImg().bitmapData;

		[Embed(source="Background.png")]
		public static var Background:Class;
		public static var background:BitmapData = new Background().bitmapData;
		
		[Embed(source="Tutorial.png")]
		public static var Tutorial:Class;
		public static var tutorial:BitmapData = new Tutorial().bitmapData;
		
		[Embed(source="BackStaticClouds.png")]
		public static var BackStaticClouds:Class;
		public static var backStaticClouds:BitmapData = new BackStaticClouds().bitmapData;
		
		[Embed(source="FrontStaticClouds.png")]
		public static var FrontStaticClouds:Class;
		public static var frontStaticClouds:BitmapData = new FrontStaticClouds().bitmapData;
		
		[Embed(source="CloudsBack.png")]
		public static var CloudsBack:Class;
		public static var cloudsBack:BitmapData = new CloudsBack().bitmapData;
		
		[Embed(source="CloudsFront.png")]
		public static var CloudsFront:Class;
		public static var cloudsFront:BitmapData = new CloudsFront().bitmapData;
		
		[Embed(source="CloudsMain.png")]
		public static var CloudsMain:Class;
		public static var cloudsMain:BitmapData = new CloudsMain().bitmapData;	
		
		[Embed(source="Mute.png")]
		public static var MuteIcon:Class;
		public static var muteIcon: BitmapData = new MuteIcon().bitmapData;
		
		[Embed(source="Speaker.png")]
		public static var SpeakerIcon:Class;
		public static var speakerIcon: BitmapData = new SpeakerIcon().bitmapData;
		
		
		[Embed(source= "Sniglet-ExtraBold.otf",
                            fontName="Sniglet",
							fontFamily="SnigletFamily",
							embedAsCFF=false,
                            mimeType="application/x-font")]
		public static var Sniglet:Class;
		
		
		[Embed(source="BubblePop.mp3")]
		public static const BubblePop:Class;		
		public static var bubblePop:Sound = new Res.BubblePop() as Sound;
		
		[Embed(source="Menu.mp3")]
		public static const Menu:Class;		
		public static var menu:Sound = new Res.Menu() as Sound;
		
		[Embed(source="Woosh.mp3")]
		public static const Woosh:Class;		
		public static var woosh:Sound = new Res.Woosh() as Sound;
		
		public function Res()
		{
		}
	}
}