package com.millermedeiros.gui.scroll {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Control scroll slider
	 * @author Miller Medeiros (http://www.millermedeiros.com)
	 */
	public class ScrollSlider extends Sprite{
		
		protected var _scroll:Scroll;
		protected var _bg:Sprite;
		protected var _bar:Sprite;
		
		protected var _marginX:int;
		protected var _marginY:int;
		
		protected var _isVertical:Boolean;
		protected var _scalePerc:Boolean;
		
		protected var _scrollEvent:String;
		protected var _disableEvent:String;
		protected var _enableEvent:String;
		
		protected var _isEnabled:Boolean;
		
		/**
		 * Constructor, build scroll slider
		 * @param	scroll	Scroll object
		 * @param	bg	Background
		 * @param	bar	Slider bar
		 * @param	isVertical	If slider is vertical and controls Y-axis
		 * @param	marginX	Horizontal margin of the bar
		 * @param	marginY	Vertical margin og the bar
		 * @param	scalePerc	Scale bar based on the ratio of content size and slider size
		 */
		public function ScrollSlider(scroll:Scroll, bg:Sprite, bar:Sprite, isVertical:Boolean = true, marginX:int = 0, marginY:int = 0, scalePerc:Boolean = true) {
			_scroll = scroll;
			_bg = bg;
			_bar = bar;
			_isVertical = isVertical;
			_marginX = marginX;
			_marginY = marginY;
			_scalePerc = scalePerc;
			_bar.x = _marginX;
			_bar.y = _marginY;
			
			addChild(_bg);
			addChild(_bar);
			
			if (_isVertical) {
				_scrollEvent = ScrollEvent.SCROLL_Y;
				_disableEvent = ScrollEvent.DISABLE_Y;
				_enableEvent = ScrollEvent.ENABLE_Y;
			}else {
				_scrollEvent = ScrollEvent.SCROLL_X;
				_disableEvent = ScrollEvent.DISABLE_X;
				_enableEvent = ScrollEvent.ENABLE_X;
			}
			_scroll.addEventListener(_enableEvent, enable, false, 0, true);
			_scroll.addEventListener(_disableEvent, disable, false, 0, true);
			
			updateSize(null);
			enable(null);
		}
		
		/**
		 * Scroll content after clicking the background
		 * @param	e	CLICK event
		 */
		private function bgClick(e:MouseEvent):void {
			var perc:Number = (_isVertical)? e.localY / _bg.height : e.localX / _bg.width;
			if (_isVertical) _scroll.scrollToPercY(perc);
			else _scroll.scrollToPercX(perc);
		}
		
		/**
		 * Update slider position based on scroll percentual
		 * @param	e	SCROLL event
		 */
		protected function updatePosition(e:ScrollEvent):void {
			if (_isVertical) _bar.y = (_bg.height - _marginY * 2 - _bar.height) * e.endPercY + _marginY;
			else _bar.x = (_bg.width - _marginX * 2 - _bar.width) * e.endPercX + _marginX;
		}
		
		/**
		 * Enable slider drag
		 */
		protected function enable(e:ScrollEvent):void {
			updateSize(null);
			_bg.addEventListener(MouseEvent.CLICK, bgClick, false, 0, true);
			_bar.addEventListener(MouseEvent.MOUSE_DOWN, dragBar, false, 0, true);
			_scroll.addEventListener(_scrollEvent, updatePosition, false, 0, true);
			_scroll.addEventListener(ScrollEvent.UPDATE_BOUNDS, updateSize, false, 0, true);
			if (e && this.hasEventListener(e.type)) dispatchEvent(e);
			_isEnabled = true;
		}
		
		/**
		 * Disable slider drag
		 */
		protected function disable(e:ScrollEvent):void {
			dragStop(null);
			updateSize(null);
			_bg.removeEventListener(MouseEvent.CLICK, bgClick);
			_bar.removeEventListener(MouseEvent.MOUSE_DOWN, dragBar);
			_scroll.removeEventListener(_scrollEvent, updatePosition);
			_scroll.removeEventListener(ScrollEvent.UPDATE_BOUNDS, updateSize);
			if (e && this.hasEventListener(e.type)) dispatchEvent(e);
			_isEnabled = false;
		}
		
		/**
		 * Stop drag the bar
		 * @param	e	MOUSE_UP event
		 */
		private function dragStop(e:Event):void {
			_bar.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollContent);
			stage.removeEventListener(Event.MOUSE_LEAVE, dragStop);
			scrollContent(null);
		}
		
		/**
		 * Start to drag the bar
		 * @param	e	MOUSE_DOWN event
		 */
		private function dragBar(e:MouseEvent):void {
			var bounds:Rectangle = (_isVertical)? new Rectangle(_marginX, _marginY, 0, _bg.height - _marginY*2 - _bar.height) : new Rectangle(_marginX, _marginY, _bg.width - _marginX*2 - _bar.width, 0);
			_bar.startDrag(false, bounds);
			stage.addEventListener(MouseEvent.MOUSE_UP, dragStop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, scrollContent);
			stage.addEventListener(Event.MOUSE_LEAVE, dragStop);
		}
		
		/**
		 * Scroll the content based on the position of the bar
		 * @param	e	MOUSE_MOVE event
		 */
		private function scrollContent(e:MouseEvent):void {
			if (_isVertical) _scroll.scrollToPercY(percent);
			else _scroll.scrollToPercX(percent);
		}
		
		/**
		 * Scale bar based on content size and scroll bounds
		 */
		private function updateSize(e:ScrollEvent):void {
			if (_scalePerc) {
				var perc:Number;
				if (_isVertical) {
					perc = Math.min(Math.max(_scroll.bounds.height / _scroll.offsetHeight, 0.2), 1);
					_bar.height = (_bg.height * perc) - (_marginY * 2);
				}
				else {
					perc = Math.min(Math.max(_scroll.bounds.width / _scroll.offsetWidth, 0.2) , 1);
					_bar.width = (_bg.width * perc) - (_marginX * 2);
				}
			}
			var evt:ScrollEvent = new ScrollEvent(_scrollEvent);
			evt.endX = _scroll.content.x;
			evt.endY = _scroll.content.y;
			evt.endPercX = _scroll.scrollPercX;
			evt.endPercY = _scroll.scrollPercY;
			updatePosition(evt);
		}
		
		/**
		 * Remove listeners childs and instances
		 */
		public function destroy():void {
			disable(null);
			if (_bar) removeChild(_bar);
			if (_bg) removeChild(_bg);
			_bar = null;
			_bg = null;
			_scroll = null;
		}
		
		/**
		 * Return scroll percentual value based on bar position
		 */
		public function get percent():Number {
			var perc:Number = (_isVertical)? (_bar.y - _marginY) / (_bg.height - _marginY * 2 - _bar.height) : (_bar.x - _marginX) / (_bg.width - _marginX * 2 - _bar.width);
			return Math.max(Math.min(perc, 1), 0);
		}
		
		/**
		 * If the ScroolSlider is enabled
		 */
		public function set enabled(value:Boolean):void {
			if (value) enable(null);
			else disable(null);
		}
		public function get enabled():Boolean { return _isEnabled; }
		
	}
	
}