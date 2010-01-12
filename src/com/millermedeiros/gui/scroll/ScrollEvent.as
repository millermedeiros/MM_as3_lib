package com.millermedeiros.gui.scroll {
	import flash.events.Event;
	
	/**
	 * Scroll event class
	 * @author Miller Medeiros (http://www.millermedeiros.com)
	 */
	public class ScrollEvent extends Event {
		
		public static const SCROLL_X:String = "scrollX";
		public static const SCROLL_Y:String = "scrollY";
		public static const ENABLE_X:String = "enableX";
		public static const ENABLE_Y:String = "enableY";
		public static const DISABLE_X:String = "disableX";
		public static const DISABLE_Y:String = "disableY";
		public static const UPDATE_BOUNDS:String = "updateBounds";
		
		public var endY:int;
		public var endX:int;
		public var endPercX:Number;
		public var endPercY:Number;
		
		public function ScrollEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new ScrollEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ScrollEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}