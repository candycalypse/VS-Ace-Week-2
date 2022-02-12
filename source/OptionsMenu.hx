package;

import flixel.input.gamepad.FlxGamepad;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Change if the arrows come from the bottom or the top."),
			new IceNotesOption("Toggle ice notes on certain songs. Turn off for classic gameplay."),
			/*new MiddlescrollOption("Put your lane in the center or on the right. (FREEPLAY ONLY)"),*/
			new GhostTapOption("If enabled, you will not lose health or get a miss when you tap a button."),
			new Judgement("Customize how many frames you have to hit the note."),
			#if desktop
			new FPSCapOption("Change the highest amount of FPS you can have."),
			#end
			new ScrollSpeedOption("Edit your scroll speed value."),
			new AccuracyDOption("Change how accuracy is calculated. (Accurate = Simple, Complex = Millisecond Based)"),
			new ResetButtonOption("Toggle pressing R to instantly die."),
			new CustomizeGameplay("Drag around the ratings to your liking.")
		]),
		new OptionCategory("Appearance", [
			new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new HealthBarOption("The color of the healthbar now fits with everyone's icons."),
			new LaneUnderlayOption("Toggles if the notes have a black background behind them for visibility."),
			new CamZoomOption("Toggle the camera zoom in-game."),
			#if desktop
			new RainbowFPSOption("Change the FPS counter to flash rainbow."),
			new FPSOption("Turn the FPS counter on or off."),
			new CpuStrums("The CPU's strumline lights up when a note hits it, like Boyfriend's strumline."),
			#end
			new ScoreScreen("Show a list of all your stats at the end of a song/week."),
			new ShowInput("Display every single input in the score screen."),
		]),
		new OptionCategory("Miscellaneous", [
			#if desktop
			new ReplayOption("View replays"),
			#end
			new FlashingLightsOption("Toggle flashing lights that can cause epileptic seizures and strain."),
			new Optimization("Removes everything except your notes and UI. Great for poor computers that cannot handle effects."),
			new BotPlay("Showcase your charts and mods with autoplay."),
		])
		
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var descriptionText:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	var black:FlxSprite;

	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFF63bcff;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		black = new FlxSprite(0).loadGraphic(Paths.image('blackFade'));
		black.setGraphicSize(Std.int(black.width * 1.1));
		black.antialiasing = true;
		black.scrollFactor.set();
		black.updateHitbox();
		add(black);

		blackBorder = new FlxSprite(FlxG.width - 560, 10).makeGraphic(110, 100, FlxColor.BLACK);
		blackBorder.alpha = 0.5;
		add(blackBorder);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.isOption = true;
			controlLabel.y -= -200;
			grpControls.add(controlLabel);
		}

		currentDescription = "none";

		descriptionText = new FlxText(FlxG.width - 460, 10, 450, currentDescription, 12);
		descriptionText.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.borderSize = 2;
		descriptionText.scrollFactor.set();

		//FlxTween.tween(descriptionText,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		//FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		super.create();

		changeSelection(0);
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				FlxG.switchState(new MainMenuState());
			else if (controls.BACK)
			{
				isCat = false;
				descriptionText.text = "Please select a category.";
				grpControls.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
					controlLabel.isOption = true;
					controlLabel.screenCenter(X);
					controlLabel.y -= -200;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}
				
				curSelected = 0;
				
				changeSelection(curSelected);
			}

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeSelection(1);
				}
			}
			
			if (FlxG.keys.justPressed.UP)
				changeSelection(-1);
			if (FlxG.keys.justPressed.DOWN)
				changeSelection(1);
			
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
					
					descriptionText.text = currentDescription;
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					descriptionText.text = currentDescription;
				else
					descriptionText.text = currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset -= 0.1;
				}
				else if (FlxG.keys.pressed.RIGHT)
					FlxG.save.data.offset += 0.1;
				else if (FlxG.keys.pressed.LEFT)
					FlxG.save.data.offset -= 0.1;
				
				descriptionText.text = currentDescription;
			}
		

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
						trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					add(descriptionText);
					for (i in 0...currentSelectedCat.getOptions().length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
						controlLabel.isOption = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
					}
					curSelected = 0;
				}
				
				changeSelection();
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category.";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				descriptionText.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				descriptionText.text = currentDescription;
		}
		else
			descriptionText.text = currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}