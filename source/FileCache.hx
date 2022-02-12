import haxe.io.Path;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.xml.Access;
import lime.utils.Assets;

#if cpp
import sys.FileSystem;
#end
class FileCache
{
    public static var instance:FileCache;

    // so it doesn't brick your computer lol!
    public var cachedGraphics:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	var music = [];
    var sounds = [];

    public var sharedSprites:Map<String, String> = new Map<String, String>();
    public var wrathSprites:Map<String, String> = new Map<String, String>();

    // public var wrathEndCutsceneSprites:FlxTypedGroup<Character>;

    public var amountLoaded = 0;
	var imagesLoaded = 0;
    public var progress:Float = 0;
	var imageProgress:Float = 0;
    public var loaded = false;
	public var loadedImages = false;

    function new()
	{
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
            if(StringTools.endsWith(i, "txt")) continue;

			music.push(i);
		}
        
        for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/sounds")))
        {
            sounds.push(i);
        }
	}

    public static function loadFiles()
    {
        instance = new FileCache();

		instance.loadMusic();
		instance.loadSounds();
        
		if (FlxG.save.data.cacheImages)
		{
			instance.loadSharedSprites();
		}
    }

    public function fromSparrow(id:String, xmlName:String)
    {
        var graphic = get(id);
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		frames = new FlxAtlasFrames(graphic);
		var Description = Assets.getText(Paths.file('images/$xmlName.xml', id.split('_')[0]));

		var data:Access = new Access(Xml.parse(Description).firstElement());

		for (texture in data.nodes.SubTexture)
		{
			var name = texture.att.name;
			var trimmed = texture.has.frameX;
			var rotated = (texture.has.rotated && texture.att.rotated == "true");
			var flipX = (texture.has.flipX && texture.att.flipX == "true");
			var flipY = (texture.has.flipY && texture.att.flipY == "true");

			var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width),
				Std.parseFloat(texture.att.height));

			var size = if (trimmed)
			{
				new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth),
					Std.parseInt(texture.att.frameHeight));
			}
			else
			{
				new Rectangle(0, 0, rect.width, rect.height);
			}

			var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

			var offset = FlxPoint.get(-size.left, -size.top);
			var sourceSize = FlxPoint.get(size.width, size.height);

			if (rotated && !trimmed)
				sourceSize.set(size.height, size.width);

			frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
		}

        return frames;
    }

    public function get(id:String)
    {
        return cachedGraphics.get(id);
    }

    public function load(id:String, path:String, library:String)
    {
        var graph = FlxGraphic.fromAssetKey(Paths.image(path, library));
        graph.persist = true;
        graph.destroyOnNoUse = false;
        cachedGraphics.set(id,graph);
    }

	public function loadMusic()
	{
		sys.thread.Thread.create(() -> {
			for (i in music)
			{
				FlxG.sound.cache(Paths.inst(i));
				FlxG.sound.cache(Paths.voices(i));

                trace(Paths.inst(i));
                trace(Paths.voices(i));

				updateProgress();
				updateImageProgress();
			}

			if (imageProgress == 100)
			{
                onAssetsLoaded();
            }
		});
	}

    public function loadSounds() {
        sys.thread.Thread.create(() -> {
			for (i in sounds)
			{
				FlxG.sound.cache(Paths.sound(new Path(i).file, 'shared'));
				updateProgress();
				updateImageProgress();
			}

			if (imageProgress == 100)
			{
                onAssetsLoaded();
            }
		});
    }

    public function loadSharedSprites()
    {
        // Note assets
        sharedSprites.set('shared_notesDefault', 'NOTE_assets');
        sharedSprites.set('shared_notesIce', 'IceArrow_Assets');

        // Generic Character Assets
		sharedSprites.set('shared_bf-cold', 'characters/bf-cold');
        sharedSprites.set('shared_bf-retro', 'characters/bf-retro');
        sharedSprites.set('shared_bf-ace', 'characters/bf-ace');

        // Basic Assets
        sharedSprites.set('shared_ace', 'characters/ace');
        sharedSprites.set('shared_bf-playerace', 'characters/bf-playerace');
		sharedSprites.set('shared_ace-old', 'characters/ace-old');
        sharedSprites.set('shared_gf', 'characters/gf');
        sharedSprites.set('shared_gf-retro', 'characters/gf-retro');
        sharedSprites.set('shared_sakuroma', 'characters/sakuroma');

        sys.thread.Thread.create(() -> {
            for(i in sharedSprites.keys())
            {
                load(i, sharedSprites.get(i), 'shared');
                updateProgress();
				updateImageProgress();
            }

            if (imageProgress == 100)
            {
                onAssetsLoaded();
            }
        });
    }

    /*public function loadWrathSprites()
    {
        wrathSprites.set('wrath_flames', 'flames_colorchange');
        wrathSprites.set('wrath_crystals', 'Crystals');
        wrathSprites.set('wrath_crack', 'HellCrack');
        wrathSprites.set('wrath_saku', 'SakuBop');
        wrathSprites.set('wrath_vortex', 'Vortex');
        wrathSprites.set('wrath_ground', 'ground');
        wrathSprites.set('wrath_frontRocks', 'frontRocks');
        wrathSprites.set('wrath_gem1', 'gem1');
        wrathSprites.set('wrath_gem2', 'gem2');
        wrathSprites.set('wrath_runes', 'runes_glow');
		wrathSprites.set('wrath_runes2', 'runes_glow2');

        sys.thread.Thread.create(() -> {
            for(i in wrathSprites.keys())
            {
                load(i, wrathSprites.get(i), 'wrath');
                updateProgress();
				updateImageProgress();
            }

            if (imageProgress == 100)
            {
                onAssetsLoaded();
            }
        });
    }*/

    /*public function constructCutscenes()
    {
		wrathEndCutsceneSprites = new FlxTypedGroup<Character>();

        for(i in 1...9)
        {
            var endSprite:Character = new Character(0, 0, 'retro-end' + i);
            endSprite.alpha = 0.0000000001;
            wrathEndCutsceneSprites.add(endSprite);
			//wrathEndCutsceneSprites.members[i - 1] = endSprite;
			updateProgress();
        }
    }*/

    public function onAssetsLoaded()
    {
        if(loaded) return;

		/*if (FlxG.save.data.cacheCutscenes)
		{
			constructCutscenes();
		}*/

        loaded = true;
    }

	public function updateProgress()
	{
		amountLoaded++;
		progress = HelperFunctions.truncateFloat(amountLoaded / (Lambda.count(sharedSprites) + music.length + sounds.length + (FlxG.save.data.cacheCutscenes ? 8 : 0)) * 100, 2);
	}

	// Sprite caching relies on images being cached first. Also needs to include music
	public function updateImageProgress()
	{
		imagesLoaded++;
		imageProgress = HelperFunctions.truncateFloat(imagesLoaded / (Lambda.count(sharedSprites) + music.length + sounds.length) * 100, 2);
	}
}