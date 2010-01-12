package com.millermedeiros.color {
	
	/**
	 * Class used to create a color fade between any number of colors
	 * @author Miller Medeiros (www.millermedeiros.com)
	 */
	public class ColorFade {
		
		private var _colors:Array;
		private var _positions:Array;
		
		/**
		 * Constructor - Create a ColorFade object to store color infos
		 * - Ex: var _fade:ColorFade = new ColorFade([0x00FF00, 0x0000FF]);
		 * @param	colorArr	Array with RGB hexadecimal color values to be used in the "gradient"
		 * @param	positionArr	Array of color distribution ratios (Numbers between 0 and 1). 0 equals to left corner and 1 equals to right corner.
		 */
		public function ColorFade(colorArr:Array = null, positionArr:Array = null) {
			colorArr = (!colorArr)? new Array(0x000000, 0xFFFFFF) : colorArr;
			setColors(colorArr, positionArr);
		}
		
		/**
		 * Return a color based on the position of the entire "gradient" 
		 * - ALERT: use getAllColors() when getting colors for a huge number of items very often (for speed optimization)
		 * @param	position	Percentual value of the position of the color inside the "gradient" (Number between 0 and 1)
		 * @return	Hexadecimal color
		 */
		public function getColor(position:Number):uint {
			
			var startColor:uint;
			var endColor:uint;
			
			if (_colors.length > 2) {
				
				// check previous and next positions
				function checkLess(element:Number, index:int, arr:Array):Boolean {
					return (element <= position);
				}
				function checkGreater(element:Number, index:int, arr:Array):Boolean {
					return (element >= position); 
				}
				
				// set previous and next color
				var less:Array = _positions.filter(checkLess);
				if (!less.length) less.push(_positions[0]);
				var greater:Array = _positions.filter(checkGreater);
				if (!greater.length) greater.push(_positions[_positions.length - 1]);
				
				startColor = _colors[less.length - 1];
				endColor = _colors[_colors.length - greater.length];
				
				// get relative position based on previous color and next color
				var startPosition:Number = less[less.length - 1];
				var endPosition:Number = greater[0];
				position = (startPosition != endPosition)? (position - startPosition) / (endPosition - startPosition) : 1;
				
			} else{
				startColor = _colors[0];
				endColor = _colors[1];
			}
			
			return fadeHex(startColor, endColor, position);
			
		}
		
		/**
		 * Separete each color channel and return the fade between the 2 colors based on current color ratio/position
		 * @param	startColor	RGB hexadecimal color - color at the position 0
		 * @param	endColor	RGB hexadeciaml color - color at the position 1
		 * @param	position	Color position
		 * @return
		 */
		public static function fadeHex(startColor:uint, endColor:uint, position:Number):uint {
			var r:Number = startColor >> 16;
			var g:Number = startColor >> 8 & 0xFF;
			var b:Number = startColor & 0xFF;
			r += ((endColor >> 16) - r) * position;
			g += ((endColor >> 8 & 0xFF) - g) * position;
			b += ((endColor & 0xFF) - b) * position;
			return(r << 16 | g << 8 | b);
		}
		
		/**
		 * Get all colors of the color fade (FASTER)
		 * @param	numItems	Number of items in the "gradient"
		 * @return	Array with all hexadecimal colors
		 */
		public function getAllColors(numItems:int):Array {
			
			var colors:Array = new Array();
			var perc:Number = 1 / (numItems - 1);
			var prevColor:int = 0;
			var nextColor:int = 1;
			var curPos:Number;
			var prevPos:Number = _positions[0];
			var nextPos:Number = _positions[1];
			var relativePos:Number;
			
			if(numItems >= _colors.length){
				for (var i:int = 0; i < numItems; i++) {
					curPos = i * perc;
					if (curPos >= nextPos && prevColor < (_colors.length-1)) {
						prevColor++;
						nextColor += (nextColor < _colors.length - 1)? 1 : 0;
					}
					prevPos = _positions[prevColor];
					nextPos = _positions[nextColor];
					relativePos = (prevPos != nextPos)? (curPos - prevPos) / (nextPos - prevPos) : 1;
					colors.push(fadeHex(_colors[prevColor], _colors[nextColor], relativePos));
				}
			} else {
				for (var j:int = 0; j < numItems; j++) {
					colors.push(this.getColor(j * perc));
				}
			}
			return colors;
		}
		
		/**
		 * Set the colors and positions
		 * @param	colorArr	Array with RGB hexadecimal color values to be used in the "gradient"
		 * @param	positionArr	Array of color distribution ratios (Numbers between 0 and 1). 0 equals to left corner and 1 equals to right corner.
		 */
		public function setColors(colorArr:Array, positionArr:Array = null):void {
			_colors = colorArr;
			// set automatic positions based on number of colors
			if (!positionArr) {
				_positions = new Array();
				var total:int = _colors.length;
				var ratio:Number = 1 / (total - 1);
				var prevPos:Number = 0;
				for (var i:int = 0; i < total; i++) {
					_positions.push(prevPos);
					prevPos += ratio;
				}
			}else {
				_positions = positionArr;
			}
		}
		
		/**
		 * Returns array of used colors 
		 */
		public function get colors():Array {
			return _colors;
		}
		
		/**
		 * Returns array with colors positions
		 */
		public function get positions():Array {
			return _positions;
		}
		
	}
	
}