package pony.ui.gui.slices;

using StringTools;

/**
 * SliceTools
 * @author AxGord <axgord@gmail.com>
 */
class SliceTools {

	public static function parseSliceName(name:String):SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2(slice(name, 2, 'v'));
		else if (check(name, 2, 'h'))
			SliceData.Hor2(slice(name, 2, 'h'));
		else if (check(name, 3, 'v'))
			SliceData.Vert3(slice(name, 3, 'v'));
		else if (check(name, 3, 'h'))
			SliceData.Hor3(slice(name, 3, 'h'));
		else if (check(name, 4))
			SliceData.Four(slice(name, 4));
		else if (check(name, 6, 'v'))
			SliceData.Vert6(slice(name, 6, 'v'));
		else if (check(name, 6, 'h'))
			SliceData.Hor6(slice(name, 6, 'h'));
		else if (check(name, 9))
			SliceData.Nine(slice(name, 9));
		else
			SliceData.Not(name);
	}

	public static function getType(name:String):SliceData {
		return if (check(name, 2, 'v'))
			SliceData.Vert2();
		else if (check(name, 2, 'h'))
			SliceData.Hor2();
		else if (check(name, 3, 'v'))
			SliceData.Vert3();
		else if (check(name, 3, 'h'))
			SliceData.Hor3();
		else if (check(name, 4))
			SliceData.Four();
		else if (check(name, 6, 'v'))
			SliceData.Vert6();
		else if (check(name, 6, 'h'))
			SliceData.Hor6();
		else if (check(name, 9))
			SliceData.Nine();
		else
			SliceData.Not();
			return null;
	}

	public static function getNames(name:String):Array<String> {
		return if (check(name, 2, 'v'))
			slice(name, 2, 'v');
		else if (check(name, 2, 'h'))
			slice(name, 2, 'h');
		else if (check(name, 3, 'v'))
			slice(name, 3, 'v');
		else if (check(name, 3, 'h'))
			slice(name, 3, 'h');
		else if (check(name, 4))
			slice(name, 4);
		else if (check(name, 6, 'v'))
			slice(name, 6, 'v');
		else if (check(name, 6, 'h'))
			slice(name, 6, 'h');
		else if (check(name, 9))
			slice(name, 9);
		else
			[name];
	}
	
	@:extern private static inline function check(name:String, n:Int, letter:String = ''):Bool {
		return name.indexOf('{slice$n$letter}') != -1;
	}
	
	private static function slice(name:String, n:Int, letter:String = ''):Array<String> {
		var s = name.split('{slice$n$letter}');
		return [for (i in 0...n) s[0] + i + s[1]];
	}
	
}