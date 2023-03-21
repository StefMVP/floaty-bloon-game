	package
{
	import com.chartboost.plugin.air.Chartboost;
	import com.chartboost.plugin.air.ChartboostEvent;
	import com.milkmangames.nativeextensions.AdMob;
	import com.milkmangames.nativeextensions.AdMobAdType;
	import com.milkmangames.nativeextensions.AdMobAlignment;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.RateBox;
	import com.milkmangames.nativeextensions.events.AdMobErrorEvent;
	import com.milkmangames.nativeextensions.events.AdMobEvent;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.milkmangames.nativeextensions.ios.IAd;
	import com.milkmangames.nativeextensions.ios.IAdBannerAlignment;
	import com.milkmangames.nativeextensions.ios.IAdContentSize;
	import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.events.IAdErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.IAdEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	import GameObjects.BackStaticClouds;
	import GameObjects.Background;
	import GameObjects.Bird;
	import GameObjects.CloudsBack;
	import GameObjects.CloudsFront;
	import GameObjects.CloudsMain;
	import GameObjects.FastBird;
	import GameObjects.FrontStaticClouds;
	import GameObjects.Leaderboard;
	import GameObjects.LinePlaceholder;
	import GameObjects.MuteButton;
	import GameObjects.NormalBird;
	import GameObjects.PauseButton;
	import GameObjects.PlayAgainButton;
	import GameObjects.Player;
	import GameObjects.PlayerString;
	import GameObjects.RateButton;
	import GameObjects.Res;
	import GameObjects.ResumeButton;
	import GameObjects.ScoreScreen;
	import GameObjects.SlowBird;
	import GameObjects.SpeedNowIncreasing;
	import GameObjects.StartButton;
	import GameObjects.Title;
	import GameObjects.Tutorial;
	
	import avmplus.getQualifiedClassName;
	import avmplus.getQualifiedSuperclassName;
	
	import org.as3commons.collections.LinkedList;
	
	[SWF(width='640',height='1136',frameRate='60')]
	
	public class BalloonGame extends Sprite
	{
		/****************************
		   Global Variables
		 ****************************/
		public static var frameCount:int;
		private var chartboost:Chartboost;
		private var player:Player;
		private var playerString:PlayerString;
		private var startButton:StartButton;
		private var playAgainButton:PlayAgainButton;
		private var scoreScreen:ScoreScreen;
		private var pauseButton:PauseButton;
		private var muteButton:MuteButton;
		private var rateButton:RateButton
		private var resumeButton:ResumeButton;
		private var leaderboard:Leaderboard;
		private var currentScore:TextField;
		private var lastScoreTextField:TextField;
		private var highScoreTextField:TextField;
		private var scoreCount:int = 0;
		private var lastScoreIncrease:int;
		private var gamePaused:Boolean = true;
		private var gameOver:Boolean = false;
		private var initialStart:Boolean = true;		
		private var highScore:SharedObject;
		public static var isMuted:SharedObject;
		private var gameObjectsDisplayLevel:int = 7;
		private var playerDisplayLevel:int = 6;
		public var frontStaticClouds:FrontStaticClouds;
		public var backStaticClouds:BackStaticClouds;
		public static var collisionList:CollisionList;
		private var iAd:IAd;
		private var iAdAvailable:Boolean;
		private var shouldShowIAd:Boolean = false;
		private var iAdTimer:Timer;
		private var firstRun:Boolean = true;
		private var tutorial:Tutorial;
		private var scoreScreenTimer:Timer;
		public static var constYSpeedIncrement:Number;
		public static var constFramesUntilSpeedIncrease:int = 420;
		private var spawnBuffer:int = -1;
		private var shouldCheckSpeedIncrease:Boolean = true;
		public static var ySpeedDifficultyAdd:Number = 0;
		private var resumeTouchID:int = -1;
		private var pauseTouchID:int= -1;
		private var startGameTouchID:int= -1;
		private var playAgainTouchID:int= -1;
		private var tutorialTouchID:int= -1;
		private var rightTouchID:int= -1;
		private var leftTouchID:int= -1;
		private var rateButtonTouchID:int = -1;
		private var muteButtonTouchID:int = -1;
		private var leaderboardTouchID:int = -1;
		public static var initObjectYSpeed:Number;
		private var birdSpawnRate:int = 60;
		public static var globalScaleX:Number;
		public static var globalScaleY:Number; 
		public static var gameStageWidth:int;
		public static var gameStageHeight:int;
		public static var gameObjectArrayList:LinkedList = new LinkedList();
		private var gameCenterEnabled:Boolean;
		private var showChartBoost:Boolean = true;
		private var deathCounter:int = 0;
		private var ppiScale:Number = 1;
		private var googleGamesEnabled:Boolean;
		
		public function BalloonGame()
		{
			super();
			
			try
			{
				highScore = SharedObject.getLocal("highScore");
				if (highScore.data['highScore'] == null)
				{
					highScore.data['highScore'] = 0;
					highScore.flush();
				}
				isMuted = SharedObject.getLocal("isMuted");
				if(isMuted.data['isMuted'] == null)
				{
					isMuted.data['isMuted'] = "False";
					isMuted.flush();
				}
			}
			catch (ex:Error)
			{
				trace(ex.message);
			}
			
			if (initialStart)
			{
				init();
			}
		}
		
		private function init():void
		{
			stage.quality = "low";
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		    stage.align = StageAlign.TOP_LEFT;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			gameStageHeight = stage.fullScreenHeight;
			gameStageWidth = stage.fullScreenWidth;
			
			ppiScale = flash.system.Capabilities.screenDPI / 326;
			globalScaleX = (stage.fullScreenWidth / 640);
			globalScaleY = (stage.fullScreenHeight / 1136);
			initObjectYSpeed = 3.75*globalScaleX;
			constYSpeedIncrement = 1*globalScaleX;
			//globalScaleX = ppiScale;
			//globalScaleY = ppiScale;
			
			Font.registerFont(Res.Sniglet);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchEventHandler);
			stage.addEventListener(TouchEvent.TOUCH_END, touchReleaseHandler);
			stage.addEventListener(Event.RESIZE, resize);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, clickEventHandler);
		
			var background:Background = new Background();
			background.scaleX = background.scaleY = globalScaleX;
			background.width = gameStageWidth;
			background.height = gameStageHeight;
			background.x = gameStageWidth / 2;
			background.y = gameStageHeight / 2;			
			addChild(background);
			
			var title:Title = new Title();
			title.scaleX = title.scaleY = globalScaleX;
			title.x = gameStageWidth / 2;
			title.y = gameStageHeight / 4;
			addChild(title);
			
			startButton = new StartButton();
			startButton.scaleX = startButton.scaleY = globalScaleX;
			startButton.x = gameStageWidth / 2;
			startButton.y = gameStageHeight / 1.6;

			addChildAt(startButton, this.numChildren);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			
			muteButton = new MuteButton();
			muteButton.scaleX = muteButton.scaleY = globalScaleX;
			muteButton.x = gameStageWidth - (gameStageWidth * .08);
			muteButton.y = gameStageWidth * .08;
			
			if(isMuted.data['isMuted'] == "True")
			{
				muteButton.setIcon("Mute");
			}
			else if(isMuted.data['isMuted'] == "False")
			{
				muteButton.setIcon("UnMute");
			}
			
			this.addChildAt(muteButton, this.numChildren);
			stage.addEventListener(Event.ENTER_FRAME, frameCounter);
			try
			{
				initIAds();
				initAdMob();
				initRateBox();
				
				if (GameCenter.isSupported())
				{
					initGameCenter();
				}
				else if (GoogleGames.isSupported())
				{
					initGoogleGames();
				}
				
				
				initChartBoost();
				
				
			}
			catch (e:Error)
			{
				trace(e.message);
			}
		}
		
		private function resize(e:Event):void
		{
			stage.removeEventListener(Event.RESIZE, resize);
			gameStageHeight = stage.fullScreenHeight;
			gameStageWidth = stage.fullScreenWidth;
			
			globalScaleX = (stage.fullScreenWidth / 640);
			globalScaleY = (stage.fullScreenHeight / 1136);
		}
		
		private function initGoogleGames():void
		{
			GoogleGames.create();
			GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED,onSignedIn);
			GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_FAILED,onSignInFailed);
			GoogleGames.games.signIn();
		}
		
		private function onSignedIn(e:GoogleGamesEvent):void
		{
			trace("player signed in – ready to use google games services!");
			googleGamesEnabled = true;
		}
		private function onSignInFailed(e:GoogleGamesEvent):void
		{
			trace("something went wrong signing in.");
			googleGamesEnabled = false;
		}
		
		private function initChartBoost():void
		{
			chartboost = Chartboost.getInstance();
			chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_FAILED, chartBoostFailed);
			chartboost.addEventListener(ChartboostEvent.INTERSTITIAL_SHOWED, chartBoostShowed);
			if (Chartboost.isAndroid()) {
				chartboost.init("X", "X");
			} else if (Chartboost.isIOS()) {
				chartboost.init("X", "X");
			}			
		}
		
		private function chartBoostFailed(e:ChartboostEvent):void
		{
			trace(e.toString());
		}
		
		private function chartBoostShowed(e:ChartboostEvent):void
		{
			trace(e.toString());
		}
		
		private function initGameCenter():void
		{
			if(GameCenter.isSupported())
			{
				GameCenter.create();
				
				if(!GameCenter.gameCenter.isGameCenterAvailable())
				{
					trace("GameCenter is not enabled on this device.");
					return;
				}
				
				GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED,onAuthSucceeded);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED,onAuthFailed);
				GameCenter.gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_OPENED,onViewOpened);
				GameCenter.gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_CLOSED,onViewClosed);
				GameCenter.gameCenter.addEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED,onScoreReported);
				GameCenter.gameCenter.addEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED,onScoreFailed);
				
				GameCenter.gameCenter.authenticateLocalUser();	
				
			}
			else
			{
				trace("this device is not running iOS.");
				return;
			}
		}
		
		private function onAuthSucceeded(e:GameCenterEvent):void
		{
			trace("game center logged in.");
			gameCenterEnabled = true;			
		}
		private function onAuthFailed(e:GameCenterErrorEvent):void
		{
			trace("game center login failed.");			
			gameCenterEnabled = false;
		}
		
		private function onViewOpened(e:GameCenterEvent):void
		{
			// view opened- you might want to stop sounds or pause here.
			
		}
		private function onViewClosed(e:GameCenterEvent):void
		{
			// view closed – you might want to restore sounds, unapause, etc. here.
			
		}
		
		private function showLeaderBoard():void
		{		
			if (GameCenter.isSupported() && gameCenterEnabled)
			{
				GameCenter.gameCenter.showLeaderboardForCategory("FloatyBloon");
			}	
			else if (GoogleGames.isSupported() && googleGamesEnabled)
			{
				GoogleGames.games.showLeaderboard("X");
			}
				
		}
		
		private function onScoreReported(e:GameCenterEvent):void
		{
			trace("score submitted!");
		}
		private function onScoreFailed(e:GameCenterErrorEvent):void
		{
			trace("an error occurred reporting score.");
		}
		
		private function initRateBox():void
		{
			if (RateBox.isSupported())
			{
				if (Chartboost.isAndroid()) {
					RateBox.create("air.com.KoalaStudios.FloatyBloon","Rate Floaty Bloon","Please rate us, and leave any feedback you may have.");
				} else if (Chartboost.isIOS()) {
					RateBox.create("842258037","Rate Floaty Bloon","Please rate us, and leave any feedback you may have.");
				}		
				
				// causes rating prompts to redirect to an existing example app on the store,
				// because your own app has not yet been published. Remember to remove this
				// line when you're doing testing and ready to publish!
			}
		}
		
		/*START iAds Functions*/
		private function initIAds():void
		{
			if (IAd.isSupported())
			{
				iAd = IAd.create();
				if (!IAd.iAd.isIAdAvailable())
				{
					iAdAvailable = false;
					trace("this device doesn't have iAd support.");
					return;
				}
				IAd.iAd.addEventListener(IAdEvent.BANNER_ACTION_BEGIN, onBannerActionBegin);
				IAd.iAd.addEventListener(IAdEvent.BANNER_ACTION_FINISHED, onBannerActionFinished);
				IAd.iAd.addEventListener(IAdEvent.BANNER_AD_LOADED, onBannerAdLoaded);
				IAd.iAd.addEventListener(IAdErrorEvent.BANNER_AD_FAILED, onBannerAdFailed);
				IAd.iAd.createBannerAd(IAdBannerAlignment.BOTTOM, IAdContentSize.PORTRAIT);
				
				IAd.iAd.setBannerVisibility(false, false);
			}
			else
			{
				iAdAvailable = false;
				trace("iad only works on iOS!");
				return;
			}		
			
			
		}
		
		private function onBannerActionBegin(e:IAdEvent):void
		{
			trace("the user started interacting with an ad.");
			pause();
		} 
		
		private function onBannerActionFinished(e:IAdEvent):void
		{
			trace("the user finished interacting with an ad.");
		}
		
		private function onBannerAdLoaded(e:IAdEvent):void
		{
			//trace("Banner loaded");
			shouldShowIAd = true;
		}
		
		private function onBannerAdFailed(e:IAdErrorEvent):void
		{
			//trace("Banner failed.");
			shouldShowIAd = false;
		}
		
		/*END iAds Functions*/ /*BEGIN Ad mob Functions*/
		private function initAdMob():void
		{
			
			if (AdMob.isSupported)
			{
				AdMob.init("X", "X");
				AdMob.addEventListener(AdMobErrorEvent.FAILED_TO_RECEIVE_AD, onFailedReceiveAd);
				AdMob.addEventListener(AdMobEvent.RECEIVED_AD, onReceiveAd);
				AdMob.showAd(AdMobAdType.BANNER, AdMobAlignment.LEFT, AdMobAlignment.BOTTOM);
				AdMob.setVisibility(false);				
			}
			else
			{
				trace("AdMob won't work on this platform!");
				return;
			}
		}
		
		private function onFailedReceiveAd(e:AdMobErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onReceiveAd(e:AdMobEvent):void
		{
			//trace("ad has loaded!");
		}
		
		/*END Ad mob Functions*/
		
		private function gameInit():void
		{
				if (currentScore != null)
				{
					//this.removeChild(currentScore);
					currentScore = null;
				}
				
				gamePaused = true;
				
				scoreScreen = new ScoreScreen();
				scoreScreen.scaleX = scoreScreen.scaleY = globalScaleX;
				scoreScreen.x = gameStageWidth / 2;
				scoreScreen.y = (gameStageHeight / 3) + (gameStageHeight * .88);
				addChild(scoreScreen);
				
				var widthOfScoreWindow:int = gameStageWidth * .733;
				var padding:int = ((gameStageWidth - widthOfScoreWindow) / 2);
				
				playAgainButton = new PlayAgainButton();
				playAgainButton.scaleX = playAgainButton.scaleY = globalScaleX;
				playAgainButton.x = padding + playAgainButton.width/2;
				playAgainButton.y = gameStageHeight * 1.53;
				addChild(playAgainButton);
				
				rateButton = new RateButton();
				rateButton.scaleX = rateButton.scaleY = globalScaleX;
				rateButton.x = gameStageWidth - rateButton.width/2 - padding;
				rateButton.y = gameStageHeight * 1.53;
				addChild(rateButton);
				
				leaderboard = new Leaderboard();
				leaderboard.scaleX = leaderboard.scaleY = globalScaleX;
				leaderboard.x = gameStageWidth /2;
				leaderboard.y = gameStageHeight * 1.71;
				addChild(leaderboard);
				
				lastScoreTextField = new TextField();
				lastScoreTextField.scaleX = lastScoreTextField.scaleY = globalScaleX;
				lastScoreTextField.x = gameStageWidth / 2 + (gameStageWidth / 8);
				
				lastScoreTextField.y = scoreScreen.y - (scoreScreen.height/13);
				lastScoreTextField.autoSize = TextFieldAutoSize.LEFT;
				lastScoreTextField.defaultTextFormat = new TextFormat('Sniglet', 75, 0xCC4646);
				lastScoreTextField.embedFonts = true;
				lastScoreTextField.text = scoreCount.toString();
				addChild(lastScoreTextField);
				
				highScoreTextField = new TextField();
				highScoreTextField.scaleX = highScoreTextField.scaleY = globalScaleX;
				highScoreTextField.x = gameStageWidth / 2 + (gameStageWidth / 8); 
				highScoreTextField.y = lastScoreTextField.y + lastScoreTextField.height * 1.2;
				highScoreTextField.autoSize = TextFieldAutoSize.LEFT;
				highScoreTextField.defaultTextFormat = new TextFormat('Sniglet', 75, 0x009EFF);
				highScoreTextField.embedFonts = true;
				highScoreTextField.text = highScore.data['highScore'];
				addChild(highScoreTextField);
				
				scoreScreenTimer = new Timer(10);
				scoreScreenTimer.addEventListener(TimerEvent.TIMER,moveGameInitScreenUp);
				scoreScreenTimer.start();
		}
		
		private function moveGameInitScreenUp(e:Event):void
		{		
			if(scoreScreen.y <= gameStageHeight / 3)
			{
				scoreScreenTimer.stop();
				scoreScreenTimer.removeEventListener(TimerEvent.TIMER,moveGameInitScreenUp);
				scoreScreenTimer = null;
				
				return;
			}
			var increment:int = 30*globalScaleX;
			scoreScreen.y -= increment;
			playAgainButton.y -= increment;
			rateButton.y -= increment;
			highScoreTextField.y -= increment
			lastScoreTextField.y -= increment;
			leaderboard.y -= increment;
		}
		
		private function startGame():void
		{
			
			birdSpawnRate = 60;
			gameOver = false;
			if (player != null)
			{
				removeChild(player);
				gameObjectArrayList.remove(player);
				player = null;
			}			
			
			if (firstRun == true)
			{		
				removeObjectsOnStart();
				tutorial = new Tutorial();
				tutorial.width = gameStageWidth;
				tutorial.height = gameStageHeight;
				tutorial.x = gameStageWidth / 2;
				tutorial.y = gameStageHeight / 2;			
				addChild(tutorial);
			}
			else
			{
				spawnBuffer = -1;
				gamePaused = false;
				scoreCount = 0;
				frameCount = 0;
				shouldCheckSpeedIncrease = true;
				ySpeedDifficultyAdd = 0;
				resumeTouchID = -1;
				pauseTouchID = -1;
				startGameTouchID = -1;
				playAgainTouchID = -1;
				tutorialTouchID = -1;
				rightTouchID = -1;
				leftTouchID = -1;
				removeObjectsOnStart();
				rateButton = null;
				scoreScreen = null;
				playAgainButton  = null;
				tutorial = null;
				
				gameObjectArrayList.clear();
				
				addSky();
				addScoreTextfield();

				
			   	addPlayer(gameStageWidth / 2, gameStageHeight *.72);
		
				pauseButton = new PauseButton();
				pauseButton.scaleX = pauseButton.scaleY = globalScaleX;
				pauseButton.x = gameStageWidth * .08;
				pauseButton.y = gameStageWidth * .08;
				this.addChildAt(pauseButton, this.numChildren);	
				
				try
				{
					IAd.iAd.setBannerVisibility(false, false);
					AdMob.setVisibility(false);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
		}
		
		private function removeObjectsOnStart():void
		{
						
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				
				var object:Object;
				var objectType:String;
				
				object = this.getChildAt(i);
				objectType = getQualifiedClassName(object);
				if (objectType != "GameObjects::Background" && objectType != "GameObjects::Player" && objectType != "GameObjects::MuteButton")
				{
					object.parent.removeChild(object);
					object = null;
				}				
			}			
		}
		
		private function addScoreTextfield():void
		{
			currentScore = new TextField();
			currentScore.scaleX = currentScore.scaleY = globalScaleX;
			currentScore.x = gameStageWidth / 2 - currentScore.width/2;
			currentScore.y = 5;		
			currentScore.autoSize = TextFieldAutoSize.CENTER;
			var format:TextFormat = new TextFormat('Sniglet', 120, 0x222F5B);
			format.align = TextFormatAlign.CENTER;
			currentScore.defaultTextFormat = format;
			
			currentScore.embedFonts = true;
			this.addChildAt(currentScore, this.numChildren);
		}
		
		private function endGame():void
		{ 			
			deathCounter++;
			gameOver = true;
			if (player != null)
			{
				playerString.endGame();
				//player = null;
				playerString = null;
			}
			var object:Object;
			var objectType:String;
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				object = this.getChildAt(i);
				objectType = getQualifiedClassName(object);
				
				if (objectType == "GameObjects::CloudsMain")
				{
					(object as CloudsMain).endGame();
				}
				else if (objectType == "GameObjects::CloudsBack")
				{
					(object as CloudsBack).endGame();
				}
				else if (objectType == "GameObjects::CloudsFront")
				{
					(object as CloudsFront).endGame();
				}
				else if (objectType == "GameObjects::LinePlaceholder")
				{
					(object as LinePlaceholder).endGame();
				}
				else if (getQualifiedSuperclassName(object) == "GameObjects::Bird")
				{
					(object as Bird).endGame();
				}	
			}			
			
			collisionList.dispose();
			collisionList = null;
			
			//Save Highscore
			if (highScore.data['highScore'] == null)
			{
				highScore.data['highScore'] = scoreCount;
			}
			else if (scoreCount > highScore.data['highScore'])
			{
				highScore.data['highScore'] = scoreCount;
			}
			highScore.flush();
			
			if(gameCenterEnabled)
			{
				GameCenter.gameCenter.reportScoreForCategory(scoreCount,"FloatyBloon");
			}
			else if (googleGamesEnabled)
			{
				GoogleGames.games.submitScore("X", scoreCount);
			}
			
			removeObjectsOnStart();
			
			gameInit();
			
			showAds();
			//birdArray = null;
			
		}
		
		private function showAds():void
		{
			try
			{
				if (shouldShowIAd)
				{
					IAd.iAd.setBannerVisibility(true, true);					
				}
				else
				{
					AdMob.setVisibility(true);
				}

				if(deathCounter % 4 == 0)
				{
					chartboost.cacheInterstitial();
				}
				else if(deathCounter % 5 == 0)
				{
					chartboost.showInterstitial();
				}
			}
			catch(e:Error)
			{
				trace(e.Message);
			}
			
		}
		
		private function frameCounter(e:Event):void
		{
			frameCount++;	
			
			var object:Object;
			var objectType:String;
			for (var i:int = this.numChildren - 1; i >= 0; i--)
			{
				object = this.getChildAt(i);
				objectType = getQualifiedClassName(object);
				
				if (objectType == "GameObjects::CloudsMain")
				{
					if (!gamePaused && !gameOver)
						(object as CloudsMain).loop();
				}
				else if (objectType == "GameObjects::CloudsBack")
				{
					if (!gamePaused && !gameOver)
						(object as CloudsBack).loop();
				}
				else if (objectType == "GameObjects::SpeedNowIncreasing")
				{
					if (!gamePaused && !gameOver)
						(object as SpeedNowIncreasing).loop();
				}
				else if (objectType == "GameObjects::CloudsFront")
				{
					if (!gamePaused && !gameOver)
						(object as CloudsFront).loop();
				}
				else if (objectType == "GameObjects::LinePlaceholder")
				{
					if (!gamePaused && !gameOver)
						(object as LinePlaceholder).loop();
				}
				else if (getQualifiedSuperclassName(object) == "GameObjects::Bird")
				{
					if (!gamePaused && !gameOver)
						(object as Bird).loop();
				}	
				else if (objectType == "GameObjects::Player")
				{
					if (!gamePaused && !gameOver)
						(object as Player).loop();
					else if(gameOver)
						(object as Player).endGameLoop();
				}	
				else if (objectType == "GameObjects::PlayerString")
				{
					if (!gamePaused && !gameOver)
						(object as PlayerString).loop();
				}		
			}		
			
			if (!gameOver && !gamePaused)
			{
				if (birdSpawnRate > 24)
				{
					
					if (scoreCount > 0 && shouldCheckSpeedIncrease == true)
					{
						if (scoreCount % (constFramesUntilSpeedIncrease/60) == 0)
						{
							spawnBuffer = 100;		
							shouldCheckSpeedIncrease = false;
						}
					}
					
					if (spawnBuffer == 50)
					{
						yourSpeedisNowIncreasing();
						birdSpawnRate -= 6;
						ySpeedDifficultyAdd += constYSpeedIncrement;
						player.incMaxSpeed();
						playerString.incMaxSpeed();
					}
					else if (spawnBuffer <= -1)
					{
						shouldCheckSpeedIncrease = true;
						birdSpawner();
					}
					
					spawnBuffer--;
				}
				else
				{
					birdSpawner();
				}
				if (currentScore != null)
				{
					currentScore.text = scoreCount.toString();
					currentScore.x = gameStageWidth / 2 - currentScore.width/2;
				}
				
				if (collisionList != null)
				{
					var collisions:Array = collisionList.checkCollisions();
					if (collisions.length > 0)
					{
						endGame();
					}
				}	
			}
		}
		
		private function birdSpawner():void
		{			
			if (frameCount % birdSpawnRate == 0)
			{
				spawnBirds(1)
			}
		}
		
		private function yourSpeedisNowIncreasing():void
		{
			var speedNowIncreasing:SpeedNowIncreasing = new SpeedNowIncreasing(1, gameStageWidth / 2 );
			addChildAt(speedNowIncreasing, gameObjectsDisplayLevel);
		}
		
		private function spawnBirds(spawnY:int):void
		{
			var birdDir:String;
			var spawnX:int;
			
			//0 = Slow, 1 = Normal, 2 = Fast
			var birdType:int = Math.floor(Math.random() * 3);
			var constPossibleSpots:int = determineNumSpots(birdType);
			
			var numGaps:int = Math.floor(Math.random() * 5 + 5);
			var isGapArray:Array = new Array(constPossibleSpots);
			var gapPadding:int = 150*globalScaleX;
			
			var linePlaceholder:LinePlaceholder = new LinePlaceholder(spawnY, player, this);
			addChild(linePlaceholder);			
			gameObjectArrayList.add(linePlaceholder);
			
			//Determine the Gaps
			for (var i:int = 0; i < numGaps; i++)
			{
				var gapTemp:int = Math.floor(Math.random() * constPossibleSpots)
				while (gapAlreadyExists(isGapArray, gapTemp) == true)
				{
					gapTemp = Math.floor(Math.random() * constPossibleSpots);
				}
				isGapArray[gapTemp] = true;
			}
			for (var i:int = 0; i < isGapArray.length; i++)
			{
				if (!isGapArray[i])
				{
					isGapArray[i] = false;
				}
			}
			
			//Determine the direction of the bird
			if (Math.floor(Math.random() * 2) == 0)
			{
				birdDir = Dir.LEFT;
				//spawnX for the first bird on the line
				spawnX = 0 - gameStageWidth / 40;
			}
			else
			{
				birdDir = Dir.RIGHT;
				//spawnX for the first bird on the line
				spawnX = gameStageWidth + gameStageWidth / 40;
			}
			
			for (var i:int = 0; i < constPossibleSpots; i++)
			{
				var wasLastSpotBird:Boolean;
				//There needs to be a bird
				if (isGapArray[i] == false)
				{
					//Make sure there aren't too many birds in a row
					if (isGapArray[i-1] == false && isGapArray[i-2] == false && isGapArray[i-3] == false && isGapArray[i-4] == false && isGapArray[i-5] == false )
					{
						if (birdDir == Dir.LEFT)
						{
							spawnX += gapPadding;
						}
						else if (birdDir == Dir.RIGHT)
						{
							spawnX -= gapPadding;
						}
					}
					//Actually spawn a bird
					else 
					{
						var bird:Bird = addBird(birdDir, spawnX, spawnY, birdType);
						if (birdDir == Dir.LEFT)
						{
							spawnX += bird.width + 10*globalScaleX;
						}
						else if (birdDir == Dir.RIGHT)
						{
							spawnX -= bird.width + 10*globalScaleX;
						}
					}
				}
				//There needs to be a gap..
				else
				{	
					//This prevents 1 bird from being alone..
					if (isGapArray[i - 1] == false && isGapArray[i - 2] == true)
					{
						//To ensure the gaps stay balanced, make the next gap open.
						isGapArray[i + 1] = true;
						var bird:Bird = addBird(birdDir, spawnX, spawnY, birdType);
						if (birdDir == Dir.LEFT)
						{
							spawnX += bird.width + 10*globalScaleX;
						}
						else if (birdDir == Dir.RIGHT)
						{
							spawnX -= bird.width + 10*globalScaleX;
						}
					}
					//Actually spawn a gap
					else
					{
						if (birdDir == Dir.LEFT)
						{
							spawnX += gapPadding;
						}
						else if (birdDir == Dir.RIGHT)
						{
							spawnX -= gapPadding;
						}
					}
				}
			}
		}
		
		private function determineNumSpots(birdType:int):int
		{
			var numSpots:int;
			//Slow Birds
			if (birdType == 0)
			{
				numSpots = 15;
			}
			//Normal Birds
			else if (birdType == 1)
			{
				numSpots = 18;
			}
			//Fast Birds
			else if (birdType == 2)
			{
				numSpots = 21;
			}
			else
			{
				numSpots = 0;
			}
			return numSpots;
		}
		
		private function gapAlreadyExists(gapLocation:Array, gapToCheck:int):Boolean
		{
			if (gapLocation[gapToCheck] == true)
			{
				return true;
			}
			return false;
		}
		
		private function addPlayer(xLocation:int, yLocation:int):void
		{
			player = new Player(xLocation, yLocation);
			player.scaleX = player.scaleY = globalScaleX;
			playerString = new PlayerString(xLocation, yLocation + (player.height /2), player.width, player.height);
			collisionList = new CollisionList(player);
			this.addChildAt(player, playerDisplayLevel);
			this.addChildAt(playerString, playerDisplayLevel);
			gameObjectArrayList.add(player);
		}
		
		private function addBird(dir:String, spawnX:int, spawnY:int, birdType:int):Bird
		{
			var birdTypes:Array = new Array("Slow", "Normal", "Fast");
			var bird:Bird;
			
			if (birdType == 0)
			{
				bird = new SlowBird(dir, spawnX, spawnY, player);
			}
			else if (birdType == 1)
			{
				bird = new NormalBird(dir, spawnX, spawnY, player);
			}
			else if (birdType == 2)
			{
				bird = new FastBird(dir, spawnX, spawnY, player);
			}
			collisionList.addItem(bird);
			this.addChildAt(bird, gameObjectsDisplayLevel);
			gameObjectArrayList.add(bird);
			return bird;
		}
		
		private function addSky():void
		{
			var backClouds:CloudsBack = new CloudsBack(gameStageWidth /2, gameStageHeight / 2);
			backClouds.scaleX = backClouds.scaleY = globalScaleX;		
		    this.addChildAt(backClouds, 1);
			gameObjectArrayList.add(backClouds);
		    var backClouds1:CloudsBack= new CloudsBack(gameStageWidth /2, (gameStageHeight / 2) - backClouds.height);
			backClouds1.scaleX = backClouds1.scaleY = globalScaleX;
		    this.addChildAt(backClouds1, 2);
			gameObjectArrayList.add(backClouds1);
			
			backStaticClouds = new BackStaticClouds();
			backStaticClouds.scaleX = backStaticClouds.scaleY = globalScaleX;
			backStaticClouds.y = gameStageHeight - backStaticClouds.height / 2;
			backStaticClouds.x = gameStageWidth / 2;
			this.addChildAt(backStaticClouds, 3);
			gameObjectArrayList.add(backStaticClouds);
			
			var mainClouds:CloudsMain = new CloudsMain(gameStageWidth / 2, gameStageHeight / 2);
			mainClouds.scaleX = mainClouds.scaleY = globalScaleX;
			this.addChildAt(mainClouds, 4);
			var mainClouds1:CloudsMain = new CloudsMain(gameStageWidth / 2, (gameStageHeight / 2) - mainClouds.height);
			mainClouds1.scaleX = mainClouds1.scaleY = globalScaleX;
			this.addChildAt(mainClouds1, 5);
			gameObjectArrayList.add(mainClouds);
			
			frontStaticClouds = new FrontStaticClouds();
			frontStaticClouds.scaleX = frontStaticClouds.scaleY = globalScaleX;
			frontStaticClouds.y = gameStageHeight - frontStaticClouds.height / 2;
			frontStaticClouds.x = gameStageWidth / 2;
			this.addChildAt(frontStaticClouds, 6);
		}
		
		private function touchEventHandler(e:TouchEvent):void
		{
			if (resumeButton != null)
			{				
				resumeTouchID =  e.touchPointID;
				if(isMuted.data['isMuted'] == "False")
				{
					Res.menu.play();
				}
				return;
			}
			if (tutorial != null)
			{
				if (tutorial.hitTestPoint(e.stageX, e.stageY, true))
				{
					tutorialTouchID =  e.touchPointID;
					firstRun = false;
					return;
				}
			}
			if (player != null && playerString != null)
			{
				if (e.stageX < gameStageWidth / 2 && e.stageY > gameStageHeight /2)
				{
					player.movePlayer(Dir.LEFT);
					playerString.movePlayer(Dir.LEFT);
					leftTouchID = e.touchPointID;
					trace("move left");
				}
				else if (e.stageX > gameStageWidth / 2 && e.stageY > gameStageHeight /2)
				{
					player.movePlayer(Dir.RIGHT);
					playerString.movePlayer(Dir.RIGHT);
					rightTouchID = e.touchPointID;
					trace("move right");
				}
			}
			if (startButton != null)
			{
				if (startButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					startGameTouchID = e.touchPointID;
					if(isMuted.data['isMuted'] == "False")
					{
						Res.menu.play();
					}
					return;				
				}
			}
			
			if (leaderboard != null)
			{
				if (leaderboard.hitTestPoint(e.stageX, e.stageY, true) && scoreScreenTimer == null)
				{
					leaderboardTouchID = e.touchPointID;
					if(isMuted.data['isMuted'] == "False")
					{
						Res.menu.play();
					}
					return;				
				}
			}
			if (playAgainButton != null && scoreScreenTimer == null)
			{
				if (playAgainButton.hitTestPoint(e.stageX, e.stageY, true))
				{		
					playAgainTouchID = e.touchPointID;
					playAgainButton.pushed();
					if(isMuted.data['isMuted'] == "False")
					{
						Res.menu.play();
					}
					return;
				}
			}
			if (rateButton != null && scoreScreenTimer == null)
			{				
				if (rateButton.hitTestPoint(e.stageX, e.stageY, true))
				{		
					rateButtonTouchID = e.touchPointID;
					rateButton.pushed();
					if(isMuted.data['isMuted'] == "False")
					{
						Res.menu.play();
					}
					return;
				}
			}
			if (pauseButton != null)
			{
				if (pauseButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					pauseTouchID = e.touchPointID;
					
					
					//pause();
					return;					
				}
				else if (e.stageX < gameStageHeight * .1 == true && e.stageY < gameStageHeight * .1 == true)
				{
					pauseTouchID = e.touchPointID;
					//pause();
					
					
					return;				
				}
			}
			
			if (muteButton != null)
			{
				if (muteButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					muteButtonTouchID = e.touchPointID;
					
					
					//pause();
					return;					
				}
				else if (e.stageX > gameStageWidth -(gameStageHeight * .1) == true && e.stageY < gameStageHeight * .1 == true)
				{
					muteButtonTouchID = e.touchPointID;
					//pause();
					
					
					return;				
				}
			}
		}
		
		private function touchReleaseHandler(e:TouchEvent):void
		{		
			if (resumeTouchID == e.touchPointID)
			{
				if(resumeButton.hitTestPoint(e.stageX, e.stageY,true))
				{
					resume();
					
				}
				resumeTouchID = -1;
				return;
			}			

			if (tutorialTouchID == e.touchPointID)
			{
				firstRun = false;
				startGame();
				tutorialTouchID = -1;
				return;
			}
					
			if (player != null && playerString != null)
			{
				if (leftTouchID == e.touchPointID)
				{
					player.stopPlayer(Dir.LEFT);
					playerString.stopPlayer(Dir.LEFT);
					leftTouchID = -1;
				}
				else if (rightTouchID == e.touchPointID)
				{
					player.stopPlayer(Dir.RIGHT);
					playerString.stopPlayer(Dir.RIGHT);
					rightTouchID = -1;
				}
			}			

			if (startGameTouchID == e.touchPointID)
			{
				if(startButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					startButton = null;
					startGame();
				}
				startGameTouchID = -1;
				return;
			}	
			
			if (leaderboardTouchID == e.touchPointID)
			{
				if(leaderboard.hitTestPoint(e.stageX, e.stageY, true))
				{
					showLeaderBoard();
				}
				leaderboardTouchID = -1;
				return;
			}	
	
			if (playAgainTouchID == e.touchPointID)
			{	
				if(playAgainButton.hitTestPoint(e.stageX, e.stageY, true))
				{					
					startGame();
				}
				else
				{
					playAgainButton.unpushed();					
				}
				
				playAgainTouchID = -1;
				return;
			}			
			if (rateButton != null)
			{				
				if (rateButtonTouchID == e.touchPointID)
				{	
					if(rateButton.hitTestPoint(e.stageX, e.stageY, true))
					{
						RateBox.rateBox.showRatingPrompt("Rate Floaty Bloon","We greatly value your feedback!","Rate It Now","Rate It Later","No Thanks");
					}
					rateButton.unpushed();
					rateButtonTouchID = -1;
					return;
				}
			}
			if (pauseTouchID == e.touchPointID)
			{
				pause();
				showAds();
				pauseTouchID = -1;
				return;
			}		
			
			if(muteButtonTouchID == e.touchPointID)
			{
				if(isMuted.data['isMuted'] == "True")
				{
					isMuted.data['isMuted'] = "False";
					muteButton.setIcon("UnMute");
				}
				else if(isMuted.data['isMuted'] == "False")
				{
					isMuted.data['isMuted'] = "True";
					muteButton.setIcon("Mute");
				}
				muteButtonTouchID = -1;
			}
		}
	
		private function clickEventHandler(e:MouseEvent):void
		{
			/*if (resumeButton != null)
			{
				if (resumeButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					resume();
					return;
				}
			}
			if (tutorial != null)
			{
				if (tutorial.hitTestPoint(e.stageX, e.stageY, true))
				{
					firstRun = false;
					startGame();
					return;
				}
			}			
			if (startButton != null)
			{
				if (startButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					startButton = null;
					startGame();
				}
			}
			if (playAgainButton != null)
			{
				if (playAgainButton.hitTestPoint(e.stageX, e.stageY, true))
				{					
					startGame();
				}
			}
			if (pauseButton != null)
			{
				if (pauseButton.hitTestPoint(e.stageX, e.stageY, true))
				{
					//pause();
					endGame();
				}
			}*/
		}
		

		
		private function handleDeactivate(e:Event):void
		{
			pause();
		}
		
		private function resume():void
		{
			
			if (gamePaused)
			{
				if (resumeButton != null)
				{
					resumeButton.parent.removeChild(resumeButton);
					resumeButton = null;
				}	
				gamePaused = false;
				
				IAd.iAd.setBannerVisibility(false, false);
				AdMob.setVisibility(false);
				
				pauseButton = new PauseButton();
				pauseButton.scaleX = pauseButton.scaleY = globalScaleX;
				pauseButton.x = (gameStageHeight * .08);
				pauseButton.y = (gameStageHeight * .08);
				this.addChildAt(pauseButton, this.numChildren - 1);
			}
		}
		
		private function pause():void
		{
			if (!gamePaused)
			{				
				removeChild(pauseButton);
			
				resumeButton = new ResumeButton();
				resumeButton.scaleX = resumeButton.scaleY = globalScaleX;
				resumeButton.x = gameStageWidth / 2;
				resumeButton.y = gameStageHeight / 2;
				this.addChildAt(resumeButton, this.numChildren - 1);
				
				showAds();			
				gamePaused = true;
			}
		}
		
		public function playerCrossedBird():void
		{
			if(isMuted.data['isMuted'] == "False")
			{
				Res.woosh.play();
			}
			scoreCount++;			
		}
	}
}
