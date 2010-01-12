package com.millermedeiros.gui.scroll {
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * Scroll basic functionalities
	 * @author Miller Medeiros (http://www.millermedeiros.com)
	 */
	public class Scroll extends EventDispatcher{
		
		protected var _content:DisplayObject;
		protected var _bounds:Rectangle;
		
		private var _paddingTop:int;
		private var _paddingRight:int;
		private var _paddingBottom:int;
		private var _paddingLeft:int;
		
		protected var _wheelAmount:int;
		protected var _isWheelY:Boolean;
		
		protected var _minX:int;
		protected var _maxX:int;
		protected var _minY:int;
		protected var _maxY:int;
		
		protected var _endX:int;
		protected var _endY:int;
		
		protected var _isEnabledX:Boolean;
		protected var _isEnabledY:Boolean;
		
		/**
		 * Constructor
		 * @param	content	Object that needs to be scrolled
		 * @param	bounds	
		 * @param	paddingTop	Scroll padding top (used as margin for the content)
		 * @param	paddingRight	Scroll padding right (used as margin for the content)
		 * @param	paddingBottom	Scroll padding bottom (used as margin for the content)
		 * @param	paddingLeft	Scroll padding left (used as margin for the content)
		 * @param	wheelScrollAmount	Mousewheel scroll amount
		 * @param	isWheelY	If mousewheel control Y-axis
		 */
		public function Scroll(content:DisplayObject, bounds:Rectangle, paddingTop:int = 0, paddingRight:int = 0, paddingBottom:int = 0, paddingLeft:int = 0, wheelScrollAmount:int = 30, isWheelY:Boolean = true) {
			_content = content;
			_paddingTop = paddingTop;
			_paddingRight = paddingRight;
			_paddingBottom = paddingBottom;
			_paddingLeft = paddingLeft;
			_wheelAmount = wheelScrollAmount;
			_isWheelY = isWheelY;
			
			setBounds(bounds);
			_content.x = _maxX;
			_content.y = _maxY;
		}
		
		/**
		 * Set scroll bounds
		 * @param	bounds
		 */
		public function setBounds(bounds:Rectangle):void {
			_bounds = bounds;
			refreshBounds();
			dispatchScrollEvent(ScrollEvent.UPDATE_BOUNDS);
		}
		
		/**
		 * Calculate min/max positions and add MOUSE_WHEEL listener
		 */
		private function refreshBounds():void {
			_minX = Math.min(int(_bounds.width - _content.width - _paddingRight + _bounds.x), _bounds.x + _paddingRight);
			_maxX = int(_paddingLeft + _bounds.x);
			_minY = Math.min(int(_bounds.height - _content.height - _paddingBottom + _bounds.y), _bounds.y + _paddingTop);
			_maxY = int(_paddingTop + _bounds.y);
			
			scrollToX(_content.x);
			scrollToY(_content.y);
			
			enable();
		}
		
		/**
		 * Disable scroll
		 */
		public function disable(disableX:Boolean = true, disableY:Boolean = true):void {
			enable(!disableX, !disableY);
		}
		
		/**
		 * Enable scroll
		 */
		public function enable(enableX:Boolean = true, enableY:Boolean = true):void {
			_isEnabledX = (enableX && offsetWidth > _bounds.width);
			if (_isEnabledX) {
				if (!_isWheelY) enableWheel();
				dispatchScrollEvent(ScrollEvent.ENABLE_X);
			} else {
				if (!_isWheelY) disableWheel();
				dispatchScrollEvent(ScrollEvent.DISABLE_X);
			}
			_isEnabledY = (enableY && offsetHeight > _bounds.height);
			if (_isEnabledY) {
				if (_isWheelY) enableWheel();
				dispatchScrollEvent(ScrollEvent.ENABLE_Y);
			}else {
				if (_isWheelY) disableWheel();
				dispatchScrollEvent(ScrollEvent.DISABLE_Y);
			}
		}
		
		/**
		 * Enable mouse wheel
		 */
		public function enableWheel():void {
			_content.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		}
		
		/**
		 * Disable mouse wheel
		 */
		public function disableWheel():void {
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		/**
		 * Scroll on the X-axis based on a distance amount
		 * @param	amount	Distance amount
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollByX(amount:int, dispatch:Boolean = true):void {
			scrollToX(_content.x + amount, dispatch);
		}
		
		/**
		 * Scroll on the Y-axis based on a distance amount
		 * @param	amount	Distance amount
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollByY(amount:int, dispatch:Boolean = true):void {
			scrollToY(_content.y + amount, dispatch);
		}
		
		/**
		 * Scroll on the X-axis to specific detination
		 * @param	endX	End X
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollToX(endX:int, dispatch:Boolean = true):void {
			if(_isEnabledX){
				if (endX <= _maxX && endX >= _minX) {
					_endX = endX;
				} else if (endX < _minX) {
					_endX = _minX;
				} else {
					_endX = _maxX;
				}
				_content.x = _endX;
				if (dispatch) dispatchScrollEvent(ScrollEvent.SCROLL_X);
			}
		}
		
		/**
		 * Scroll on the Y-axis based to specific detination
		 * @param	endY	End Y
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollToY(endY:int, dispatch:Boolean = true):void {
			if(_isEnabledY){
				if (endY <= _maxY && endY >= _minY) {
					_endY = endY;
				} else if (endY < _minY) {
					_endY = _minY;
				} else {
					_endY = _maxY;
				}
				_content.y = _endY;
				if (dispatch) dispatchScrollEvent(ScrollEvent.SCROLL_Y);
			}
		}
		
		/**
		 * Scroll on the X-axis based on percentual value
		 * @param	perc	Percentual value (between 0 and 1)
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollToPercX(perc:Number = 0, dispatch:Boolean = true):void {
			scrollToX( int((_minX - _maxX) * perc + _maxX), dispatch );
		}
		
		/**
		 * Scroll on the Y-axis based on percentual value
		 * @param	perc	Percentual value (between 0 and 1)
		 * @param	dispatch	If it should dispatch the SCROLL event
		 */
		public function scrollToPercY(perc:Number = 0, dispatch:Boolean = true):void {
			scrollToY( int((_minY - _maxY) * perc + _maxY), dispatch );
		}
		
		/**
		 * Handle mouse wheel event
		 * @param	e	MOUSE_WHEEL event
		 */
		protected function onMouseWheel(e:MouseEvent):void {
			var amount:int = (e.delta < 0)? -_wheelAmount : _wheelAmount;
			if (_isWheelY) scrollByY(amount);
			else scrollByX(amount);
		}
		
		/**
		 * Dispatch scroll event
		 * @param	scrollEvent	ScrollEvent name
		 */
		protected function dispatchScrollEvent(scrollEvent:String):void {
			if (this.hasEventListener(scrollEvent)) {
				var evt:ScrollEvent = new ScrollEvent(scrollEvent);
				evt.endY = _endY;
				evt.endX = _endX;
				evt.endPercY = (_maxY - _endY) / (_maxY - _minY);
				evt.endPercX = (_maxX - _endX) / (_maxX - _minX);
				dispatchEvent(evt);
			}
		}
		
		/**
		 * Remove listeners and instance references
		 */
		public function destroy():void {
			_content.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			_content = null;
			_bounds = null;
		}
		
		/// Return scroll percentage based on position
		public function get scrollPercX():Number { return (_maxX - _content.x) / (_maxX - _minX); }
		
		/// Return scroll percentage based on position
		public function get scrollPercY():Number { return (_maxY - _content.y) / (_maxY - _minY); }
		
		/// Return min X position of the content
		public function get minX():int { return _minX; }
		
		/// Return max X position of the content
		public function get maxX():int { return _maxX; }
		
		/// Return min Y position of the content
		public function get minY():int { return _minY; }
		
		/// Return max Y position of the content
		public function get maxY():int { return _maxY; }
		
		/// content of the scroller
		public function get content():DisplayObject { return _content; }
		
		/// Rectangle that represents scroll bounds
		public function get bounds():Rectangle { return _bounds; }
		
		/// Content offset height (height + padding)
		public function get offsetHeight():Number {	return _content.height + _paddingTop + _paddingBottom; }
		
		/// Content offset width (height + width)
		public function get offsetWidth():Number {	return _content.width + _paddingLeft + _paddingRight; }
		
		/// If scroll on the X-axis is enabled
		public function get enabledX():Boolean { return _isEnabledX; }
		
		public function set enabledX(value:Boolean):void {
			enable(value, _isEnabledY);
		}
		
		/// If scroll on the Y-axis is enabled
		public function get enabledY():Boolean { return _isEnabledY; }
		
		public function set enabledY(value:Boolean):void {
			enable(_isEnabledX, value);
		}
		
	}
	
}