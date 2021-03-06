package pony.heaps.ui.gui.slices;

import h2d.Tile;
import h2d.Object;
import pony.geom.Point;

/**
 * Slice4
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
@:final class Slice4 extends Node {

	private var b: SliceBase;

	public function new(tiles: Array<Tile>, repeat: Bool = false, ?parent: Object) {
		tiles.insert(2, tiles[0]);
		tiles.push(tiles[3]);
		tiles.push(tiles[0]);
		tiles.push(tiles[1]);
		tiles.push(tiles[0]);
		super(new Point(tiles[0].width * 2 + tiles[1].width, tiles[0].height * 2 + tiles[3].height), parent);
		b = new SliceBase(this, tiles, repeat ? [1, 3, 4, 5, 7] : null);
		changeWh << drawTiles;
		changeFlipx << SliceBase.unsupported;
		changeFlipy << SliceBase.unsupported;
		changeTint << b.setColor;
		drawTiles();
	}

	private function drawTiles(): Void {
		b.clear();
		b.drawTile(0);
		var w0: Float = b.w0;
		var h0: Float = b.h0;
		var w: Float = w - w0 * 2;
		var h: Float = h - h0 * 2;
		b.drawTile(1, w0, 0, w);
		b.drawTile(2, w0 + w, true);
		b.drawTile(3, 0, h0, null, h);
		b.drawTile(4, w0, h0, w, h);
		b.drawTile(5, w0 + w, h0, null, h, true);
		b.drawTile(6, 0, h0 + h, false, true);
		b.drawTile(7, w0, h0 + h, w, false, true);
		b.drawTile(8, w0 + w, h0 + h, true, true);
	}

}