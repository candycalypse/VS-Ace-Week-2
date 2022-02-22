package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	
	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var rawNoteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var originColor:Int = 0; // The sustain note's original note's color

	public var noteCharterObject:FlxSprite;

	public var isFreezeNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0; // used in nothing for now

	public var rating:String = "shit";

	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx

	private var dataSuffix:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, BLUE_NOTE, 2];
	public var arrowAngles:Array<Int> = [180, 90, 270, 0];

	//public var isParent:Bool = false;
	//public var parent:Note = null;
	//public var spotInLine:Int = 0;
	public var sussy:Bool = true;

	//public var children:Array<Note> = [];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inCharter:Bool = false, ?frozenNote:Bool = false)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		isFreezeNote = frozenNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (inCharter)
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime;
		}
		else
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime - (FlxG.save.data.offset + PlayState.songOffset);
			#if sys
			if (PlayState.isSM)
			{
				rStrumTime = Math.round(rStrumTime + Std.parseFloat(PlayState.sm.header.OFFSET));
			}
			#end
		}


		if (this.strumTime < 0 )
			this.strumTime = 0;

		this.noteData = noteData;

		if (inCharter)
		{
			if (FlxG.save.data.cacheImages)
				{
					frames = FileCache.instance.fromSparrow('shared_notesDefault', 'NOTE_assets');
				}
				else
				{
					frames = Paths.getSparrowAtlas('NOTE_assets','shared');
				}

			for (i in 0...4)
			{
				animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
				animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
				animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
			}

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			if(FlxG.save.data.antialiasing)
				antialiasing = true;
		}
		else
		{			
			if (isFreezeNote)
			{
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_notesIce', 'IceArrow_Assets');
					}
					else
					{
						frames = Paths.getSparrowAtlas('IceArrow_Assets','shared');
					}

				for (i in 0...4)
					animation.addByPrefix(dataColor[i] + 'Frozen', 'Ice Arrow ' + dataSuffix[i]); // Ice notes

				setGraphicSize(Std.int(width * 0.6));
				updateHitbox();
				offset.x += 30;
			}
			else
			{
				if (FlxG.save.data.cacheImages)
					{
						frames = FileCache.instance.fromSparrow('shared_notesDefault', 'NOTE_assets');
					}
					else
					{
						frames = Paths.getSparrowAtlas('NOTE_assets','shared');
					}

				for (i in 0...4)
				{
					animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
					animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
					animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
			}
			
			if(FlxG.save.data.antialiasing)
				antialiasing = true;
		}

		x += swagWidth * noteData;
		if (isFreezeNote)
			animation.play(dataColor[noteData] + 'Frozen');
		else
			animation.play(dataColor[noteData] + 'Scroll');
		originColor = noteData; // The note's origin color will be checked by its sustain notes

		if (FlxG.save.data.stepMania && !isSustainNote && !isFreezeNote)
		{
			// I give up on fluctuating bpms. something has to be subtracted from strumCheck to make them look right but idk what.
			// I'd use the note's section's start time but neither the note's section nor its start time are accessible by themselves
			//strumCheck -= ???

			var ind:Int = Std.int(Math.round(rStrumTime / (Conductor.stepCrochet / 2)));

			var col:Int = 0;
			col = quantityColor[ind % 8]; // Set the color depending on the beats

			animation.play(dataColor[col] + 'Scroll');
			localAngle -= arrowAngles[col];
			localAngle += arrowAngles[noteData];
			originColor = col;
		}

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			if (FlxG.save.data.downscroll) flipY = true;

			offsetX += width / 2;

			originColor = prevNote.originColor; 

			animation.play(dataColor[originColor] + 'holdend'); // This works both for normal colors and quantization colors
			updateHitbox();

			offsetX -= width / 2;

			if (inCharter)
				offsetX += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(dataColor[prevNote.originColor] + 'hold');

				if(FlxG.save.data.scrollSpeed != 1)
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * FlxG.save.data.scrollSpeed;
				else
					prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.instance.songSpeed;
				prevNote.updateHitbox();
			}
		}
		x += offsetX;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		angle = modAngle + localAngle;

		if (mustPress)
		{
			// ass
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				// Make ice notes harder to hit
				if (isFreezeNote)
				{
					if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.15)
						&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.25))
						canBeHit = true;
					else
						canBeHit = false;
				}
				else
				{
					if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
						&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
						canBeHit = true;
					else
						canBeHit = false;
				}
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
