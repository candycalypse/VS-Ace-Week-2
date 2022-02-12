package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		if(FlxG.save.data.antialiasing)
			antialiasing = true;
		if (char == 'sm')
		{
			loadGraphic(Paths.image("stepmania-icon"));
			return;
		}
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		animation.add('ace-old', [2, 3], 0, false, isPlayer);					// VS Ace: Ace icon
		animation.add('ace', [2, 3], 0, false, isPlayer);			// VS Ace: Ace Week 2 icon
		animation.add('ace-frost', [4, 3, 5], 0, false, isPlayer);			// VS Ace: Frostbite icon
		animation.add('bf-playerace', [2, 3], 0, false, isPlayer);			// VS Ace: Player Ace Icon
		animation.add('bf-cold', [0, 1], 0, false, isPlayer);				// VS Ace: BF-Cold icon
		animation.add('bf-ace', [6, 7], 0, false, isPlayer);				// VS Ace: BF-Ace icon
		animation.add('bf-retro', [8, 9], 0, false, isPlayer);				// VS Ace: BF-Retro icon
		animation.add('retro', [10, 11], 0, false, isPlayer);				// VS Ace: Retro icon
		animation.add('sakuroma', [12, 13], 0, false, isPlayer);			// VS Ace: Sakuroma icon
		animation.play(char);

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}