package pony.pixi;

import js.html.CSSStyleDeclaration;
import pony.geom.Rect;
import pony.geom.Point;
import pony.Tumbler;
import pony.magic.HasSignal;
import pony.events.Signal0;

/**
 * HtmlContainerBase
 * @author AxGord <axgord@gmail.com>
 */
class HtmlContainerBase implements HasSignal {

	public static inline var POSITION:String = 'absolute';
	public static inline var POSITION_FIXED:String = 'fixed';

	@:auto public var onResize:Signal0;

	public var app(default, null):App;

	public var targetStyle(default, set):CSSStyleDeclaration;
	public var targetRect(default, set):Rect<Float>;
	public var targetPos(default, set):Point<Float> = new Point(.0, .0);
	public var posUpdater:Tumbler = new Tumbler(true);

	private var lastRect:Rect<Float> = null;
	private var ceil:Bool;
	private var fixed:Bool;

	public function new(targetRect:Rect<Float>, ?app:App, ?targetStyle:CSSStyleDeclaration, ceil:Bool = false, fixed:Bool = false) {
		this.targetRect = targetRect;
		this.ceil = ceil;
		this.fixed = fixed;
		if (app == null)
			app = App.main;
		this.app = app;
		this.targetStyle = targetStyle;
		if (fixed) {
			js.Browser.window.addEventListener('scroll', resize);
		}
		posUpdater.onEnable << resize;
	}

	private function scrollHandler():Void {
		pony.time.DeltaTime.fixedUpdate < resize;
	}

	private function resizeHandler(scale:Float):Void {
		lastRect = {
			x: scale * (targetRect.x + targetPos.x + app.container.x / app.container.width),
			y: scale * (targetRect.y + targetPos.y + app.container.y / app.container.height),
			width: scale * targetRect.width,
			height: scale * targetRect.height
		};
		if (!fixed) {
			lastRect.x += lastRect.width;
			lastRect.y += lastRect.height;
		}
		resize();
	}

	public function resize():Void {
		if (!posUpdater.enabled) return;
		if (fixed) {
			var b = app.parentDom.getBoundingClientRect();
			targetStyle.top = px(b.top + lastRect.y);
			targetStyle.left = px(b.left + lastRect.x);
		} else {
			targetStyle.bottom = px(app.parentDom.clientHeight - lastRect.y);
			targetStyle.right = px(app.parentDom.clientWidth - lastRect.x);
		}
		targetStyle.width = px(lastRect.width);
		targetStyle.height = px(lastRect.height);
		eResize.dispatch();
	}

	@:extern private inline function px(v:Float):String return (ceil ? Std.int(v) : v) + 'px';

	private function set_targetStyle(s:CSSStyleDeclaration):CSSStyleDeclaration {
		targetStyle = s;

		if (s == null) {
			app.onResize >> resizeHandler;
			app.onFrequentResize >> resize;
		} else {
			s.position = fixed ? POSITION_FIXED : POSITION;
			app.onResize << resizeHandler;
			app.onFrequentResize << resize;
			resizeHandler(app.scale);
		}

		return targetStyle;
	}

	private function set_targetRect(v:Rect<Float>):Rect<Float> {
		if (targetRect == null
			|| v.x != targetRect.x
			|| v.y != targetRect.y
			|| v.width != targetRect.width
			|| v.height != targetRect.height
		) {
			targetRect = v;
			if (targetStyle != null)
				resizeHandler(app.scale);
		}
		return v;
	}

	private function set_targetPos(v:Point<Float>):Point<Float> {
		if (v.x != targetPos.x || v.y != targetPos.y) {
			targetPos = v;
			resizeHandler(app.scale);
		}
		return v;
	}

}