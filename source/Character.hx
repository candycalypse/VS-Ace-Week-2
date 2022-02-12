package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var iconColor:String = '';

	public var isPlayer:Bool = false;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		if(FlxG.save.data.antialiasing)
			antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// Girlfriend Code
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_gf', 'characters/gf');
					}
					else
					{
						frames = Paths.getSparrowAtlas('gf','shared',true);
					}
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);

				playAnim('danceRight');
			
			case 'gf-retro':
				iconColor = 'C42D06';
				// retrospecter gf
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_gf-retro', 'characters/gf-retro');
					}
					else
					{
						frames = Paths.getSparrowAtlas('gf-retro','shared',true);
					}
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				playAnim('danceRight');
	
			case 'ace-old':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_ace-old', 'characters/ace-old');
					}
					else
					{
						frames = Paths.getSparrowAtlas('ace-old','shared',true);
					}
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing note UP', 24, false);
				animation.addByPrefix('singLEFT', 'dad sing note right', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note LEFT', 24, false);

				playAnim('idle');

				//flipX = true;
			case 'ace':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_ace', 'characters/ace');
					}
					else
					{
						frames = Paths.getSparrowAtlas('ace','shared',true);
					}
				animation.addByPrefix('idle', 'Ace Idle', 24, false);
				animation.addByPrefix('singUP', 'Ace Up Note', 24, false);
				animation.addByPrefix('singLEFT', 'Ace Left Note', 24, false);
				animation.addByPrefix('singDOWN', 'Ace Down Note', 24, false);
				animation.addByPrefix('singRIGHT', 'Ace Right Note0', 24, false);
				animation.addByPrefix('intro', 'Ace Intro', 24, false);

				playAnim('idle');

				//flipX = true;
			case 'bf-playerace':
				iconColor = 'BAE2FF';
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_bf-playerace', 'characters/bf-playerace');
					}
					else
					{
						frames = Paths.getSparrowAtlas('player-ace','shared',true);
					}
					animation.addByPrefix('idle', 'Ace Idle', 24, false);
					animation.addByPrefix('singUP', 'Ace Up Note0', 24, false);
					animation.addByPrefix('singLEFT', 'Ace Right Note0', 24, false);
					animation.addByPrefix('singRIGHT', 'Ace Left Note0', 24, false);
					animation.addByPrefix('singDOWN', 'Ace Down Note0', 24, false);
					animation.addByPrefix('singUPmiss', 'Ace Up Note MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Ace Right Note MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Ace Left Note MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'Ace Down Note MISS', 24, false);
	
					animation.addByPrefix('Intro', 'Ace Intro', 24, false);

					
					
					animation.addByPrefix('firstDeath', "Ace dies", 24, false);
					animation.addByPrefix('deathLoop', "Ace Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "Ace Dead confirm", 24, false);
	
					playAnim('idle');
	
				flipX = true;	
			case 'sakuroma':
				iconColor = 'EB3175';
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_sakuroma', 'characters/sakuroma');
					}
					else
					{
						frames = Paths.getSparrowAtlas('sakuroma','shared',true);
					}
				animation.addByPrefix('idle', 'saku idle', 24, false);
				animation.addByPrefix('singUP', 'saku up', 24);
				animation.addByPrefix('singRIGHT', 'saku right', 24);
				animation.addByPrefix('singDOWN', 'saku down', 24);
				animation.addByPrefix('singLEFT', 'saku left', 24);

				playAnim('idle');

			case 'bf-cold' | 'bf-ace' | 'bf-retro':

				switch (curCharacter)
				{
					case 'bf-cold':
						iconColor = '31B0D1';
						if (FlxG.save.data.cacheImages)
							{
								frames = FileCache.instance.fromSparrow('shared_bf-cold', 'characters/bf-cold');
							}
							else
							{
								frames = Paths.getSparrowAtlas('bf-cold','shared',true);
							}
					case 'bf-ace':
						iconColor = '8298EF';
						if (FlxG.save.data.cacheImages)
							{
								frames = FileCache.instance.fromSparrow('shared_bf-ace', 'characters/bf-ace');
							}
							else
							{
								frames = Paths.getSparrowAtlas('bf-ace','shared',true);
							}
					case 'bf-retro':
						iconColor = '45C3F0';
						if (FlxG.save.data.cacheImages)
							{
								frames = FileCache.instance.fromSparrow('shared_bf-retro', 'characters/bf-retro');
							}
							else
							{
								frames = Paths.getSparrowAtlas('bf-retro','shared',true);
							}
				}

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				playAnim('idle');
		}

		if (isPlayer) {
			loadOffsetFile(curCharacter, true);
		} else {
			loadOffsetFile(curCharacter, false);
		}

		dance();

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String, playerSide:Bool)
	{
		var offset:Array<String> = [];

		if(playerSide)	
			offset = CoolUtil.coolTextFile(Paths.txt('images/characters/offsets/' + character + "PlayerOffsets", 'shared'));
		else
			offset = CoolUtil.coolTextFile(Paths.txt('images/characters/offsets/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
				holdTimer += elapsed;

			if (holdTimer >= Conductor.stepCrochet * 4 * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if ((animation.curAnim.name == 'hairLeft' || animation.curAnim.name == 'hairRight') && animation.curAnim.finished)
				{
					playAnim('dance' + animation.curAnim.name.substr(4));
				}
			case 'gf-retro':
				if ((animation.curAnim.name == 'hairLeft' || animation.curAnim.name == 'hairRight') && animation.curAnim.finished)
				{
					playAnim('dance' + animation.curAnim.name.substr(4));
				}
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			switch(curCharacter)
			{
				case 'gf' | 'gf-retro':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if  (danced)
						{
							playAnim('danceRight');
						}
						else
						{
							playAnim('danceLeft');
						}
					}
				default:
					playAnim('idle', forced);
				
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}
	
			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}
	

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
