package;

import openfl.display.Preloader.DefaultPreloader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curMood:String = '';
	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var portraitGF:FlxSprite;
	var portraitAceBF:FlxSprite;
	var portraitRetroBF:FlxSprite;
	var portraitRetro:FlxSprite;
	var portraitZer:FlxSprite;
	var portraitSaku:FlxSprite;

	var bgFade:FlxSprite;

	public var music:FlxSound;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

	if (PlayState.isStoryMode)
	{
		if (StoryMenuState.curWeek == 0)
		{
			music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience1', 'shared'), true, true);
            music.volume = 0;
			music.fadeIn(1, 0, 0.8);
            FlxG.sound.list.add(music);
		} else if (StoryMenuState.curWeek == 1) {
			music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience2', 'shared'), true, true);
            music.volume = 0;
			music.fadeIn(1, 0, 0.8);
            FlxG.sound.list.add(music);
		} else {
			//failsafe
		}
	}

	if (PlayState.SONG.song.toLowerCase() == 'ectospasm' || PlayState.SONG.song.toLowerCase() == 'cold-hearted')
        {
                music = new FlxSound().loadEmbedded(Paths.music('dialogueAmbience2', 'shared'), true, true);
                music.volume = 0;
                music.fadeIn(1, 0, 0.8);
                FlxG.sound.list.add(music);
        }

	switch (PlayState.SONG.song.toLowerCase())
	{
		case 'Concrete-Jungle':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Noreaster' :
			FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case  'Sub-Zero' :
			FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Frostbite':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience1', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Groundhog-Day':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Cold-Front':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Cryogenic':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'North':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Cold-Hearted':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);

		case 'Ectospasm':
			FlxG.sound.playMusic(Paths.music('dialogueAmbience2', 'shared'), 1);
			FlxG.sound.music.fadeIn(1, 0, 0.8);
	}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		// Box sprite
		box = new FlxSprite(-20, 350);
		box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
		box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		box.animation.addByPrefix('normal', 'speech bubble normal', 24);

		this.dialogueList = dialogueList;
		
		// Ace sprite
		portraitLeft = new FlxSprite(-20, 50);
		portraitLeft.frames = Paths.getSparrowAtlas('characters/portraits/AcePortraits', 'shared');
		portraitLeft.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitLeft.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitLeft.animation.addByPrefix('Shocked', 'Shocked', 24, false);
		portraitLeft.animation.addByPrefix('Embarassed', 'Embarassed', 24, false);
		portraitLeft.animation.addByPrefix('Annoyed', 'Annoyed', 24, false);
		portraitLeft.animation.addByPrefix('Blush', 'Blush', 24, false);
		portraitLeft.animation.addByPrefix('Eyeroll', 'Eyeroll', 24, false);
		portraitLeft.animation.addByPrefix('Confused', 'Confused', 24, false);
		portraitLeft.animation.addByPrefix('Smug', 'Smug', 24, false);
		portraitLeft.animation.addByPrefix('Tired', 'Tired', 24, false);
		portraitLeft.scrollFactor.set();
		portraitLeft.animation.play('Neutral', true);
		add(portraitLeft);
		portraitLeft.visible = false;

		// Bf sprite
		portraitRight = new FlxSprite(200, 75);
		portraitRight.frames = Paths.getSparrowAtlas('characters/portraits/BFPortraits', 'shared');
		portraitRight.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitRight.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitRight.scrollFactor.set();
		portraitRight.animation.play('Neutral', true);
		add(portraitRight);
		portraitRight.visible = false;

		// Gf sprite
		portraitGF = new FlxSprite(200, 75);
		portraitGF.frames = Paths.getSparrowAtlas('characters/portraits/GFPortraits', 'shared');
		portraitGF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitGF.animation.addByPrefix('Confused', 'Confused', 24, false);
		portraitGF.scrollFactor.set();
		portraitGF.animation.play('Neutral', true);
		add(portraitGF);
		portraitGF.visible = false;

		// Ace Bf sprite
		portraitAceBF = new FlxSprite(780, 55);
		portraitAceBF.frames = Paths.getSparrowAtlas('characters/portraits/AceBFPortraits', 'shared');
		portraitAceBF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitAceBF.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitAceBF.animation.addByPrefix('Sad', 'Sad', 24, false);
		portraitAceBF.animation.addByPrefix('Blush', 'Blush', 24, false);
		portraitAceBF.animation.addByPrefix('Confused', 'Confused', 24, false);
		portraitAceBF.scrollFactor.set();		
		portraitAceBF.animation.play('Neutral', true);
		add(portraitAceBF);
		portraitAceBF.scale.set(0.75, 0.75);

		portraitAceBF.visible = false;

		// Retro Bf sprite
		portraitRetroBF = new FlxSprite(780, 55);
		portraitRetroBF.frames = Paths.getSparrowAtlas('characters/portraits/RetroBFPortraits', 'shared');
		portraitRetroBF.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitRetroBF.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitRetroBF.animation.addByPrefix('Sad', 'Sad', 24, false);
		portraitRetroBF.animation.addByPrefix('Smug', 'Smug', 24, false);
		portraitRetroBF.animation.addByPrefix('Confused', 'Confused', 24, false);
		portraitRetroBF.animation.addByPrefix('Flushed', 'Flushed', 24, false);
		portraitRetroBF.scrollFactor.set();
		portraitRetroBF.animation.play('Neutral', true);
		add(portraitRetroBF);
		portraitRetroBF.scale.set(0.75, 0.75);

		portraitRetroBF.visible = false;

		// Zerktro Sprite :flushed: (based)
		portraitZer = new FlxSprite(610, 35);
		portraitZer.frames = Paths.getSparrowAtlas('characters/portraits/ZerktroPortraits', 'shared');
		portraitZer.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitZer.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitZer.animation.addByPrefix('Sad', 'Sad', 24, false);
		portraitZer.animation.addByPrefix('Smug', 'Smug', 24, false);
		portraitZer.animation.addByPrefix('Talking', 'Talking', 24, false);
		portraitZer.animation.addByPrefix('Blush', 'Blush', 24, false);
		portraitZer.animation.addByPrefix('Laugh', 'Laugh', 24, false);
		portraitZer.animation.addByPrefix('Eyeroll', 'Eyeroll', 24, false);
		portraitZer.scrollFactor.set();
		portraitZer.animation.play('Neutral', true);
		add(portraitZer);
		portraitZer.scale.set(0.65, 0.65);

		portraitZer.visible = false;
		portraitZer.flipX = true;

		// the horny moth port- i mean uh sakuromas portraits
		portraitSaku = new FlxSprite(780, 45);
		portraitSaku.frames = Paths.getSparrowAtlas('characters/portraits/SakuPortraits', 'shared');
		portraitSaku.animation.addByPrefix('Neutral', 'Neutral', 24, false);
		portraitSaku.animation.addByPrefix('Happy', 'Happy', 24, false);
		portraitSaku.animation.addByPrefix('Flirt', 'Flirt', 24, false);
		portraitSaku.animation.addByPrefix('Horny', 'Horny', 24, false); // horny??? on MY wholesome fnf mod???
		portraitSaku.animation.addByPrefix('Menacing', 'Menacing', 24, false);
		portraitSaku.animation.addByPrefix('Blush', 'Blush', 24, false);
		portraitSaku.animation.addByPrefix('Angry', 'Angry', 24, false);
		portraitSaku.animation.addByPrefix('Enraged', 'Enraged', 24, false);
		portraitSaku.animation.addByPrefix('Thinking', 'Thinking', 24, false);
		portraitSaku.animation.addByPrefix('Booba', 'Booba', 24, false);
		portraitSaku.antialiasing = FlxG.save.data.antialiasing;

		portraitSaku.scrollFactor.set();
		portraitSaku.animation.play('Neutral', true);
		add(portraitSaku);
		portraitSaku.scale.set(0.75, 0.75);

		portraitSaku.visible = false;
		portraitSaku.flipX = true;

		// Retro sprite
		portraitRetro = new FlxSprite(850, 150).loadGraphic(Paths.image('characters/portraits/BGRetroPortrait', 'shared'));
		portraitRetro.scrollFactor.set();
		add(portraitRetro);
		portraitRetro.visible = false;
		
		box.animation.play('normalOpen');
		add(box);

		box.screenCenter(X);
		box.x += 50;
		portraitLeft.screenCenter(X);
		portraitLeft.x -= 375;
		portraitRight.screenCenter(X);
		portraitRight.x += 400;
		portraitGF.screenCenter(X);
		portraitGF.x += 440;
		portraitRetro.screenCenter(X);
		portraitRetro.x -= 375;

		dropText = new FlxText(168, 477, 1000, "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = FlxColor.BLACK;
		add(dropText);

		swagDialogue = new FlxTypeText(165, 475, 1000, "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted)
		{				
			if (!isEnding)
				FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (music.playing)
						music.fadeOut(1.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						portraitGF.visible = false;
						portraitAceBF.visible = false;
						portraitRetroBF.visible = false;
						portraitRetro.visible = false;
						portraitSaku.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		else if (PlayerSettings.player1.controls.BACK && dialogueStarted)
		{
			isEnding = true;

			if (music.playing)
				music.fadeOut(1.2, 0);

			new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				box.alpha -= 1 / 5;
				bgFade.alpha -= 1 / 5 * 0.7;
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitAceBF.visible = false;
				portraitRetroBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				swagDialogue.alpha -= 1 / 5;
				dropText.alpha = swagDialogue.alpha;
			}, 5);

			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				finishThing();
				kill();
			});
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				portraitGF.visible = false;
				portraitZer.visible = false;
				portraitAceBF.visible = false;
				portraitRetroBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitLeft.animation.play(curMood, true);
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					swagDialogue.color = 0xFF3c567a;
					box.flipX = true;
				}
			case 'bf':
				portraitLeft.visible = false;
				portraitGF.visible = false;
				portraitZer.visible = false;
				portraitAceBF.visible = false;
				portraitRetroBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitRight.animation.play(curMood, true);
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					swagDialogue.color = FlxColor.fromRGB(80, 165, 235);
					box.flipX = false;
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitZer.visible = false;
				portraitAceBF.visible = false;
				portraitRetroBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitGF.animation.play(curMood, true);

				// Offset for confused portrait
				portraitGF.screenCenter(X);
				portraitGF.x += 440;
				if (curMood == 'Confused')
					portraitGF.x -= 50;

				if (!portraitGF.visible)
				{
					portraitGF.visible = true;
					swagDialogue.color = 0xFF9f72f3;
					box.flipX = false;
				}
			case 'ace':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitZer.visible = false;
				portraitGF.visible = false;
				portraitRetroBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitAceBF.animation.play(curMood, true);
				if (!portraitAceBF.visible)
				{
					portraitAceBF.visible = true;
					swagDialogue.color = 0xFF3c567a;
					box.flipX = false;
				}
			case 'retro':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitZer.visible = false;
				portraitGF.visible = false;
				portraitAceBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitRetroBF.animation.play(curMood, true);
				if (!portraitRetroBF.visible)
				{
					portraitRetroBF.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = false;
				}
			case 'zer':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitRetroBF.visible = false;
				portraitGF.visible = false;
				portraitAceBF.visible = false;
				portraitRetro.visible = false;
				portraitSaku.visible = false;
				portraitZer.animation.play(curMood, true);
				if (!portraitZer.visible)
				{
					portraitZer.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = false;
				}
			case 'saku':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitRetroBF.visible = false;
				portraitGF.visible = false;
				portraitAceBF.visible = false;
				portraitRetro.visible = false;
				portraitZer.visible = false;
				portraitSaku.animation.play(curMood, true);
				if (!portraitSaku.visible)
				{
					portraitSaku.visible = true;
					swagDialogue.color = 0xFF990e41;
					box.flipX = false;
				}
			case 'BGretro':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				portraitZer.visible = false;
				portraitGF.visible = false;
				portraitAceBF.visible = false;
				portraitRetroBF.visible = false;
				portraitSaku.visible = false;
				if (!portraitRetro.visible)
				{
					portraitRetro.visible = true;
					swagDialogue.color = FlxColor.fromRGB(42, 136, 164);
					box.flipX = true;
				}
		}

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curMood = splitName[0];
		if (curMood == '')
			curMood = 'Neutral'; // Just for cleaner logic
		curCharacter = splitName[1];
		var dialogue:String = dialogueList[0].substr(splitName[1].length + 2 + splitName[0].length).trim();
		dialogue = dialogue.replace('[Happy]',':D').replace('[Surprised]',':0').replace('[Sad]',':(');
		dialogueList[0] = dialogue;
	}
}
