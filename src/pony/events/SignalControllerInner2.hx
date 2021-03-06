package pony.events;

/**
 * SignalControllerInner2
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class SignalControllerInner2<T1, T2> {

	public var signal(default, null): Signal2<T1, T2>;
	public var stop: Bool = false;
	@:nullSafety(Off) public var listener: Listener2<T1, T2>;

	public inline function new(signal: Signal2<T1, T2>) {
		this.signal = signal;
	}

	public inline function remove(): Void {
		signal.remove(listener);
	}

	public inline function destroy(): Void {
		@:nullSafety(Off) {
			signal = null;
			listener = null;
		}
	}

}