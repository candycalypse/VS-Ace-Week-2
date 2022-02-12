package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DisclaimerState extends FlxState
{
    var selectSprite:FlxSprite;
    var confirmText:FlxText;
    var effects:Bool = true;
    var barProgress:Float = 0;

    var loadingBG:FlxSprite;
    var loadingBarBG:FlxSprite;
    var loadingBar:FlxBar;
    var loadingImage:FlxSprite;
    var continueText:FlxText;
    var disclaimer:Bool = false;
	var stopspamming:Bool = false;

	static var firstPass:Bool = false;

	override public function create():Void
	{
        PlayerSettings.init();
		KadeEngineData.initSave();
		Highscore.load();

        var description1:FlxText = new FlxText(0, 100, 0, "This mod contains different unlockables", 36);
        description1.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        description1.screenCenter(X);
        var description2:FlxText = new FlxText(0, 150, 0, "that change aspects of the game", 36);
        description2.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        description2.screenCenter(X);
        var description3:FlxText = new FlxText(0, 200, 0, "and are unlocked in different weeks", 36);
        description3.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        description3.screenCenter(X);

        var askText:FlxText = new FlxText(0, 350, 0, "Have you finished Vs.Ace week 1 before?", 36);
        askText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        askText.screenCenter(X);

        var description4:FlxText = new FlxText(0, 400, 0, "(Pressing ''yes'' will unlock bonus content from week 1)", 24);
        description4.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE);
        description4.screenCenter(X);

        selectSprite = new FlxSprite(460, 495).makeGraphic(140, 75, FlxColor.GRAY);
        var yes:FlxText = new FlxText(470, 500, "YES", 64);
        yes.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE);
        var no:FlxText = new FlxText(690, 500, "NO", 64);
        no.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE);

        confirmText = new FlxText(0, 650, 0, "Press Enter to confirm", 36);
        confirmText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        confirmText.screenCenter(X);

        add(selectSprite);
        add(description1);
        add(description2);
        add(description3);
        add(description4);
        add(askText);
        add(yes);
        add(no);
        add(confirmText);

        loadingBG = new FlxSprite(0, 0).loadGraphic(Paths.image('loading/' + FlxG.random.int(0, 2)));

        loadingBarBG = new FlxSprite(0, 700).loadGraphic(Paths.image('healthBar', 'shared'));
        loadingBarBG.screenCenter(X);

        loadingBar = new FlxBar(loadingBarBG.x + 4, loadingBarBG.y + 4, LEFT_TO_RIGHT, Std.int(loadingBarBG.width - 8), Std.int(loadingBarBG.height - 8), this,
            'barProgress', 0, 100);
        loadingBar.numDivisions = 100;
        loadingBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);

        continueText = new FlxText(0, 650, 0, "Loading", 36);
        continueText.setFormat(Paths.font("vcr.ttf"), 36, FlxColor.WHITE);
        continueText.screenCenter(X);

        loadingBarBG.setPosition(loadingBarBG.x + 0, loadingBarBG.y - 20);
        loadingBar.setPosition(loadingBar.x + 0, loadingBar.y - 20);
        continueText.setPosition(continueText.x + 0, continueText.y - 20);

        add(loadingBG);
        add(loadingBarBG);
        add(loadingBar);
        add(continueText);

        FileCache.loadFiles();
        updateLoadingText();

		super.create();
	}


    public static var fuckYouUpdateLoop:Bool = false;


	override function update(elapsed:Float)
        {
            if (!FileCache.instance.loaded)
                barProgress = FileCache.instance.progress;
            else
            {
                // Set it to loaded
                if (barProgress != 100)
                {
                    barProgress = 100;
                    continueText.text = "Hit Enter to continue";
                    continueText.screenCenter(X);
                }
    
                if (!disclaimer && (FlxG.keys.justPressed.ENTER || PlayerSettings.player1.controls.ACCEPT))
                    {
                        if (firstPass)
                        {
                            FlxG.switchState(new TitleState());
                        }
                        else
                        {
                            disclaimer = true;
                            stopspamming = true;
                            FlxTween.tween(loadingBG, {alpha: 0}, 1, {ease: FlxEase.cubeInOut, onComplete: function(flx:FlxTween) {
                                stopspamming = false;
                            }});
                            FlxTween.tween(loadingBarBG, {alpha: 0}, 1, {ease: FlxEase.cubeInOut});
                            FlxTween.tween(loadingBar, {alpha: 0}, 1, {ease: FlxEase.cubeInOut});
                            FlxTween.tween(continueText, {alpha: 0}, 1, {ease: FlxEase.cubeInOut});
        
                            FlxG.sound.play(Paths.sound('confirmMenu'));
                        }
                    }
            else if (disclaimer && !stopspamming)
                {
                    if(!fuckYouUpdateLoop)
                        {
                            FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                    selectSprite.x = 460;
                    StoryMenuState.characterUnlocked[1] = true; 
                    StoryMenuState.characterUnlocked[2] = true; 
                    fuckYouUpdateLoop = true;
                        }
                if ((FlxG.keys.justPressed.LEFT || PlayerSettings.player1.controls.LEFT_P) && selectSprite.x == 660) 
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                    selectSprite.x = 460;
                    StoryMenuState.characterUnlocked[1] = true; 
                    StoryMenuState.characterUnlocked[2] = true; 
                }
                else if ((FlxG.keys.justPressed.RIGHT || PlayerSettings.player1.controls.RIGHT_P) && selectSprite.x == 460)
                {
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                    selectSprite.x = 660;
                    StoryMenuState.characterUnlocked[1] = false; 
                    StoryMenuState.characterUnlocked[2] = false; 
                }
                else if (FlxG.keys.justPressed.ENTER || PlayerSettings.player1.controls.ACCEPT)
                {
                    FlxG.save.data.characterUnlocked = StoryMenuState.characterUnlocked; 
                    firstPass = true;
                    FlxG.switchState(new TitleState());
                }
            }
        }

            super.update(elapsed);
        }
    
        function updateLoadingText()
        {
            if (barProgress != 100)
            {
                switch(continueText.text)
                {
                    case 'Loading':
                        continueText.text = 'Loading.';
                    case 'Loading.':
                        continueText.text = 'Loading..';
                    case 'Loading..':
                        continueText.text = 'Loading...';
                    case 'Loading...':
                        continueText.text = 'Loading';
                }
    
                new FlxTimer().start(0.1, function(tmr:FlxTimer){ updateLoadingText(); });
            }
        }
    }