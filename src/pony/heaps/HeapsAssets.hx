package pony.heaps;

import h2d.Bitmap;
import h2d.Tile;
import h2d.Anim;
import h2d.Font;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import hxd.net.BinaryLoader;
import hxd.res.Any;
import hxd.res.Atlas;
import hxd.res.Loader;
import hxd.fmt.bfnt.FontParser;
import pony.Pair;
import pony.ui.AssetManager;
import pony.ui.gui.slices.SliceTools;
import pony.Fast;

@:enum abstract Ext(String) to String {
	var ATLAS = 'atlas';
	var PNG = 'png';
	var JPG = 'jpg';
	var JPEG = 'jpeg';
	var FNT = 'fnt';
	var TXT = 'txt';
	var CSS = 'css';
	var JSON = 'json';
	var CDB = 'cdb';
}

@:enum abstract HAError(String) to String {
	var ERROR_NOT_SUPPORTED = 'Type not supported';
	var ERROR_NAME_NOT_SET = 'Name not set';
	var ERROR_NAME_SET = 'Name set';
	var ERROR_NOT_LOADED = 'Asset not loaded';
}

/**
 * HeapsAssets
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class HeapsAssets {

	private static inline var SDF_ALPHA: Float = 0.5;
	private static inline var SDF_SMOOTHING: Float = 0.5;

	private static var atlases: Map<String, Pair<Loader, Atlas>> = new Map();
	private static var tiles: Map<String, Tile> = new Map();
	private static var fonts: Map<String, Font> = new Map();
	private static var texts: Map<String, String> = new Map();

	public static function load(asset: String, cb: Int -> Int -> Void): Void {
		var realAsset: String = AssetManager.getPath(asset);
		var loader: BinaryLoader = new BinaryLoader(realAsset);
		switch ext(asset) {
			case ATLAS:
				loader.load();
				loader.onLoaded = function(textBytes: Bytes): Void {
					cb(1, AssetManager.MAX_ASSET_PROGRESS);
					var path: String = realAsset.substr(0, realAsset.lastIndexOf('/') + 1);
					var imgFile: String = path + new BytesInput(textBytes).readLine();
					var imgLoader: BinaryLoader = new BinaryLoader(imgFile);
					imgLoader.load();
					imgLoader.onProgress = function(cur: Int, max: Int): Void
						if (cur != max) cb(Std.int(1 + cur / max * (AssetManager.MAX_ASSET_PROGRESS - 1)), AssetManager.MAX_ASSET_PROGRESS);
					imgLoader.onLoaded = function(bytes: Bytes): Void {
						var img: Any = Any.fromBytes(imgFile, bytes);
						atlases[asset] = new Pair(
							@:privateAccess img.loader,
							Any.fromBytes(realAsset, textBytes).to(Atlas)
						);
						cb(AssetManager.MAX_ASSET_PROGRESS, AssetManager.MAX_ASSET_PROGRESS);
					}
				}
			case FNT:
				loader.load();
				loader.onLoaded = function(fntbytes: Bytes): Void {
					cb(1, AssetManager.MAX_ASSET_PROGRESS);
					var data: String = fntbytes.toString();
					var image: Null<String> = null;
					var type: Null<String> = null;
					try {
						var xml: Fast = new Fast(Xml.parse(data)).node.font;
						image = xml.node.pages.node.page.att.file;
						try {
							type = xml.node.distanceField.att.fieldType;
						} catch (_: String) {}
					} catch (_: String) {
						var filePattern: String = '\npage id=0 file=';
						var fileIndex: Int = data.indexOf(filePattern);
						if (fileIndex != -1) {
							fileIndex += filePattern.length;
							image = data.substr(fileIndex);
							image = image.substr(0, image.indexOf('\n'));
						}
						var typePattern: String = '\ndistanceField fieldType=';
						var typeIndex: Int = data.indexOf(typePattern);
						if (typeIndex != -1) {
							typeIndex += typePattern.length;
							type = data.substr(typeIndex);
							type = type.substr(0, type.indexOf(' '));
						}
					}
					if (image == null) throw "Can't get image url";
					var path: String = realAsset.substr(0, realAsset.lastIndexOf('/') + 1);
					var imgLoader: BinaryLoader = new BinaryLoader(path + image);
					imgLoader.load();
					imgLoader.onProgress = function(cur: Int, max: Int): Void
						if (cur != max) cb(Std.int(1 + cur / max * (AssetManager.MAX_ASSET_PROGRESS - 1)), AssetManager.MAX_ASSET_PROGRESS);
					imgLoader.onLoaded = function(imgbytes: Bytes): Void {
						var font:Font = FontParser.parse(fntbytes, realAsset, function(path: String): Tile {
							return Any.fromBytes(path, imgbytes).toTile();
						});
						setFontType(font, type);
						fonts[asset] = font;
						cb(AssetManager.MAX_ASSET_PROGRESS, AssetManager.MAX_ASSET_PROGRESS);
					}

				}
			case PNG, JPG, JPEG:
				loader.load();
				loader.onProgress = function(cur: Int, max: Int): Void
					if (cur != max) cb(Std.int(cur / max * AssetManager.MAX_ASSET_PROGRESS), AssetManager.MAX_ASSET_PROGRESS);
				loader.onLoaded = function(bytes: Bytes): Void {
					tiles[asset] = Any.fromBytes(realAsset, bytes).toTile();
					cb(AssetManager.MAX_ASSET_PROGRESS, AssetManager.MAX_ASSET_PROGRESS);
				}
			case TXT, CSS, JSON, CDB:
				loader.load();
				loader.onProgress = function(cur: Int, max: Int): Void if (cur != max) cb(Std.int(cur / max * AssetManager.MAX_ASSET_PROGRESS), AssetManager.MAX_ASSET_PROGRESS);
				loader.onLoaded = function(bytes: Bytes): Void {
					texts[asset] = Any.fromBytes(realAsset, bytes).toText();
					cb(AssetManager.MAX_ASSET_PROGRESS, AssetManager.MAX_ASSET_PROGRESS);
				}
			case _:
				throw ERROR_NOT_SUPPORTED;
		}
	}

	public static inline function ext(asset: String): String {
		return asset.substr(asset.lastIndexOf('.') + 1);
	}

	public static inline function reset(asset: String): Void {
		atlases.remove(asset);
	}

	public static function texture(asset: String, ?name: String): Tile {
		return switch ext(asset) {
			case ATLAS:
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p: Null<Pair<Loader, Atlas>> = atlases[asset];
				if (p == null) throw ERROR_NOT_LOADED;
				Loader.currentInstance = p.a;
				p.b.get(name);
			case PNG, JPG, JPEG:
				if (name != null) throw ERROR_NAME_SET;
				if (!tiles.exists(asset)) throw ERROR_NOT_LOADED;
				tiles[asset];
			case _:
				throw ERROR_NOT_SUPPORTED;
		};
	}

	public static inline function image(asset: String, ?name: String): Bitmap {
		return new Bitmap(texture(asset, name));
	}

	public static function animation(asset: String, ?name: String): Array<Tile> {
		return switch ext(asset) {
			case ATLAS:
				var clname: Null<String> = null;
				if (name != null) {
					clname = SliceTools.clean(name);
					if (clname == name) {
						return [texture(asset, clname)];
					}
				} else {
					var classet: String = SliceTools.clean(asset);
					if (classet == asset) {
						return [texture(classet)];
					}
				}
				if (name == null) throw ERROR_NAME_NOT_SET;
				var p: Null<Pair<Loader, Atlas>> = atlases[asset];
				if (p == null) throw ERROR_NOT_LOADED;
				Loader.currentInstance = p.a;
				p.b.getAnim(clname);
			case PNG, JPG, JPEG:
				if (name != null) throw ERROR_NAME_SET;
				var assets: Array<String> = AssetManager.parseInterval(asset);
				if (assets.length == 1)
					assets = SliceTools.getNames(assets[0]);
				[for (e in assets) texture(e)];
			case _:
				throw ERROR_NOT_SUPPORTED;
		};
	}

	public static inline function clip(asset: String, ?name: String, ?speed: Float): Anim {
		return new Anim(animation(asset, name), speed);
	}

	public static inline function font(asset: String): Font {
		return cast fonts[asset];
	}

	public static inline function text(asset: String): String {
		return cast texts[asset];
	}

	public static function setFontType(font: Font, type: Null<String>): Void {
		switch type {
			case null:
			case 'msdf':
				font.type = SignedDistanceField(SDFChannel.MultiChannel, SDF_ALPHA, SDF_SMOOTHING);
			case 'sdf':
				font.type = SignedDistanceField(SDFChannel.Alpha, SDF_ALPHA, SDF_SMOOTHING);
			case _:
				throw 'Unsupported font type';
		}
	}

}