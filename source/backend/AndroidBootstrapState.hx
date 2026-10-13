package backend;

#if android
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import haxe.Json;
import haxe.io.Path;
import lime.system.System;
import lime.utils.Assets;
import sys.FileSystem;
import sys.io.File;

/** APK assets are not ordinary files; Lua and the mod loader need real paths. */
class AndroidBootstrapState extends FlxState
{
	static inline var MARKER = '.bundled-assets.json';
	var manifest:AndroidManifest;
	var nextState:flixel.util.typeLimit.NextState.InitialState;

	public function new(nextState:flixel.util.typeLimit.NextState.InitialState)
	{
		super();
		this.nextState = nextState;
	}
	var position:Int = 0;
	var status:FlxText;
	var failure:Bool = false;

	override public function create():Void
	{
		super.create();
		status = new FlxText(24, FlxG.height / 2 - 60, FlxG.width - 48, 'Preparando Verade...', 28);
		status.alignment = CENTER;
		add(status);
		try
		{
			var storage = System.applicationStorageDirectory;
			FileSystem.createDirectory(storage);
			Sys.setCwd(storage);
			manifest = Json.parse(Assets.getText('assets/android-files.json'));
			for (entry in manifest.files) validatePath(entry.path);
			if (FileSystem.exists(MARKER))
			{
				var old:AndroidManifest = Json.parse(File.getContent(MARKER));
				if (old.version == manifest.version && allFilesExist())
				{
					startGame();
					return;
				}
				// Remove only files previously managed by this bootstrap.
				var current:Map<String, Bool> = [];
				for (entry in manifest.files) current.set(entry.path, true);
				for (entry in old.files)
				{
					validatePath(entry.path);
					if (!current.exists(entry.path) && FileSystem.exists(entry.path) && !FileSystem.isDirectory(entry.path))
						FileSystem.deleteFile(entry.path);
				}
			}
		}
		catch (error:Dynamic) showError(error);
	}

	function startGame():Void
	{
		Language.reloadPhrases();
		FlxG.switchState(nextState.toNextState());
	}

	function allFilesExist():Bool
	{
		for (entry in manifest.files)
			if (!FileSystem.exists(entry.path)) return false;
		return true;
	}

	static function validatePath(path:String):Void
	{
		if (path == null || !StringTools.startsWith(path, 'assets/')
			|| path.split('/').contains('..') || path.split('/').contains('.') || path.split('/').contains('') || path.indexOf('\\') != -1 || path.indexOf(':') != -1)
			throw 'Invalid bundled asset path';
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (failure) return;
		try
		{
			// Yield between files so Android keeps drawing and processing events.
			var start = haxe.Timer.stamp();
			while (position < manifest.files.length && haxe.Timer.stamp() - start < 0.01)
			{
				var entry = manifest.files[position];
				var bytes = Assets.getBytes(entry.path);
				if (bytes == null) throw 'Missing APK asset: ' + entry.path;
				FileSystem.createDirectory(Path.directory(entry.path));
				File.saveBytes(entry.path + '.tmp', bytes);
				FileSystem.rename(entry.path + '.tmp', entry.path);
				position++;
			}
			status.text = 'Preparando Verade... ' + Std.int(position * 100 / manifest.files.length) + '%\n'
				+ 'Copiando arquivos do jogo. Aguarde.';
			if (position == manifest.files.length)
			{
				File.saveContent(MARKER + '.tmp', Json.stringify(manifest));
				FileSystem.rename(MARKER + '.tmp', MARKER);
				startGame();
			}
		}
		catch (error:Dynamic) showError(error);
	}

	function showError(error:Dynamic):Void
	{
		failure = true;
		status.text = 'Falha ao preparar o jogo.\nConfira o espaço livre e reinicie o app.\n' + Std.string(error);
	}
}

private typedef AndroidManifest =
{
	var version:String;
	var files:Array<{path:String, sha256:String}>;
}
#end
