import sys.FileSystem;

/**
 * PonyInstall
 * @author AxGord <axgord@gmail.com>
 */
class PonyInstall extends BaseInstall {

	public function new() super('Pony Command-Line Tools', !Config.INSTALL, true);

	override private function run():Void {
		new VSCodePluginsInstall();
		new VSCodeInsidersPluginsInstall();
		new HaxelibInstall();
		compile();
		new NpmInstall();
		new UserpathInstall();
	}

	private inline function compile():Void {
		log('Prepare for compile pony');
		if (FileSystem.exists(Config.BIN)) {
			Utils.beginColor(90);
			for (e in FileSystem.readDirectory(Config.BIN)) {
				log('Delete: $e');
				FileSystem.deleteFile(Config.BIN + e);
			}
			Utils.endColor();
		}
		log('Compile pony');
		Utils.beginColor(90);
		cmd('haxe', ['--cwd', Config.SRC, 'build.hxml']);
		Utils.endColor();
		FileSystem.deleteFile(Config.BIN + 'pony.n');
	}

}